extends SkeletonIK3D

@export var target_obj: Node
@export var raycast: RayCast3D

@onready var current_desired_target: Vector3 = Vector3.ZERO
@onready var robot = $"../../.."

var leg_in_air:bool = false



func _ready():
	start()
	
func _process(delta):
	var below = raycast.get_collision_point()
	var resting_pos = robot.global_position
	resting_pos.y = below.y
	var distance:float = (resting_pos).distance_to(target_obj.position)
	if !raycast.is_colliding():
		pass
		# print("Not colliding")
	# print("Distance: %d, below.z: %d, target.z: %d, raycast.z: %d" % [distance, below.z, target_obj.global_position.z, raycast.global_position.z])
	
	
	var max_distance = max(3.5 * robot.velocity, 0.5)
	print("Max distance: %f; actual distance: %f" % [max_distance, distance])
	if (distance > max_distance) && robot.legs_in_air < 2:
		current_desired_target = below
		leg_in_air = true
		robot.legs_in_air += 1
		print("Stepping")
	elif distance > max_distance:
		pass
		# print("step suppressed by leg threshold")
		

	target_obj.global_position = target_obj.global_position.move_toward(current_desired_target, 40*delta)
	
	if leg_in_air && target_obj.global_position.distance_to(current_desired_target) < 0.05:
		robot.legs_in_air -= 1
		leg_in_air = false
