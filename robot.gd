extends Node3D

@export var speed = 8
@export var body_height = 3

func _process(delta):
	
	var movement = Vector2(
		Input.get_axis("backward", "forward"),
		Input.get_axis("right", "left"),
	)
	
	$Raycasts.rotation_degrees.y = rad_to_deg(movement.angle())
	
	# movement
	global_position += -transform.basis.z * speed * delta * movement.x
	global_position += -transform.basis.x * speed * delta * movement.y
	
	update_body_height()

func update_body_height():
	var avg_ground_pos = ($Armature/BL_Target.global_position.y + $Armature/BR_Target.global_position.y + $Armature/FL_Target.global_position.y + $Armature/FR_Target.global_position.y)/4
	global_position.y = move_toward(global_position.y, avg_ground_pos + body_height, 0.1)
