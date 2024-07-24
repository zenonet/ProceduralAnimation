extends SkeletonIK3D

@export var target_obj: Node
@export var raycast: RayCast3D

@onready var current_desired_target: Vector3 = Vector3.ZERO
var step_start_pos:Vector3 = Vector3.ZERO
var current_pos_on_ground:Vector3 = Vector3.ZERO


@onready var robot = $"../../.."
@onready var skeleton:Skeleton3D = $".."

var leg_in_air:bool = false

func _ready():
	start()
	
func _process(delta):
	var below = raycast.get_collision_point()
	var resting_pos = robot.global_position
	resting_pos.y = below.y
	var distance:float = current_pos_on_ground.distance_to(below)
	if !raycast.is_colliding():
		pass
		# print("Not colliding")
	# print("Distance: %d, below.z: %d, target.z: %d, raycast.z: %d" % [distance, below.z, target_obj.global_position.z, raycast.global_position.z])
	
	
	var max_distance = max(2 * robot.vel, 0.5)
	print("Max distance: %f; actual distance: %f" % [max_distance, distance])
	if (distance > max_distance) && (robot.legs_in_air < 2 || false):
		current_desired_target = below
		leg_in_air = true
		robot.legs_in_air += 1
		step_starting_point = current_pos_on_ground
		step_length = distance
		# print("Starting to step to %v" % current_desired_target)
	elif distance > max_distance:
		pass
		# print("step suppressed by leg threshold")
		
	if leg_in_air:
		move_foot(delta)
		
		
var leg_force:float = 2.44
func _physics_process(delta):
	# apply force to body
	var anchor_pos = (skeleton.global_transform * skeleton.get_bone_global_pose(skeleton.find_bone(root_bone))).origin
	var force_dir = anchor_pos - current_pos_on_ground
	force_dir = Vector3.UP
	
	leg_force += (robot.global_body_height - robot.global_position.y)*0.1
	robot.apply_central_force(force_dir*leg_force)

var step_length:float = 0
@onready var step_starting_point:Vector3 = target_obj.global_position 
func move_foot(delta):
	current_pos_on_ground = current_pos_on_ground.move_toward(current_desired_target, 38*delta)
	
	var progress = current_pos_on_ground.distance_to(current_desired_target) / step_length
	#print(progress)
	target_obj.global_position = current_pos_on_ground
	
	target_obj.global_position.y += sin(progress*PI)*1.2*robot.vel
	
	if current_pos_on_ground.distance_to(current_desired_target) < 0.2:
		robot.legs_in_air -= 1
		leg_in_air = false
	
