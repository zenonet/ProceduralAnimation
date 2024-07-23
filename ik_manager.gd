extends SkeletonIK3D

@export var target_obj: Node
@export var raycast: RayCast3D

@onready var current_desired_target: Vector3 = Vector3.ZERO

func _ready():
	start()
	
func _process(delta):
	var below = raycast.get_collision_point()
	var distance:float = below.distance_to(target_obj.position)
	if !raycast.is_colliding():
		pass
		# print("Not colliding")
	# print("Distance: %d, below.z: %d, target.z: %d, raycast.z: %d" % [distance, below.z, target_obj.global_position.z, raycast.global_position.z])
	if distance > 2.5:
		current_desired_target = below

	target_obj.global_position = target_obj.global_position.move_toward(current_desired_target, delta*15)
