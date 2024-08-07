extends SkeletonIK3D

@export var target_obj: Node
@export var raycast: RayCast3D

@onready var current_desired_target: Vector3 = Vector3.ZERO
var step_start_pos:Vector3 = Vector3.ZERO
var current_pos_on_ground:Vector3 = Vector3.ZERO


@onready var robot = $"../../.."

var leg_in_air:bool = false

func _ready():
	start()
	
func _process(delta):
	var below = raycast.get_collision_point()
	if raycast.is_colliding():
		var resting_pos = robot.global_position
		resting_pos.y = below.y
		var distance:float = current_pos_on_ground.distance_to(below)

		# print("Not colliding")
		# print("Distance: %d, below.z: %d, target.z: %d, raycast.z: %d" % [distance, below.z, target_obj.global_position.z, raycast.global_position.z])
		
		
		var max_distance = max(2 * robot.velocity, 0.5)
		# print("Max distance: %f; actual distance: %f" % [max_distance, distance])
		if (distance > max_distance) && (robot.legs_in_air < 2 || false):
			current_desired_target = below
			leg_in_air = true
			robot.legs_in_air += 1
			step_starting_point = current_pos_on_ground
			step_length = distance
			# print("Starting to step to %v" % current_desired_target)
		
	if leg_in_air:
		move_foot(delta)
		
var step_length:float = 0
@onready var step_starting_point:Vector3 = target_obj.global_position 
func move_foot(delta):
	current_pos_on_ground = current_pos_on_ground.move_toward(current_desired_target, 38*delta)
	
	var progress = current_pos_on_ground.distance_to(current_desired_target) / step_length
	target_obj.global_position = current_pos_on_ground
	
	target_obj.global_position.y += sin(progress*PI)*1.2*robot.velocity
	
	if current_pos_on_ground.distance_to(current_desired_target) < 0.2:
		robot.legs_in_air -= 1
		leg_in_air = false
	
