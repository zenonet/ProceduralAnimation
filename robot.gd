extends Node3D

@export var speed = 12
@export var rotation_speed = 45
@export var body_height = 3
var legs_in_air = 0
var velocity:float = 0

func _process(delta):
	
	var rot:float = Input.get_axis("rotate_right", "rotate_left")
	rotation_degrees.y += rot*rotation_speed*delta
	
	
	var movement = Vector2(
		Input.get_axis("backward", "forward"),
		Input.get_axis("right", "left"),
	).normalized()
	
	velocity = movement.length()
	print(velocity)
	
	$Raycasts.global_position = self.global_position - (transform.basis.x*movement.y + transform.basis.z*movement.x) * 2.5
	
	# movement
	global_position += -transform.basis.z * speed * delta * movement.x
	global_position += -transform.basis.x * speed * delta * movement.y
	
	update_body_height()

func update_body_height():
	var avg_ground_pos = ($Armature/BL_Target.global_position.y + $Armature/BR_Target.global_position.y + $Armature/FL_Target.global_position.y + $Armature/FR_Target.global_position.y)/4
	global_position.y = move_toward(global_position.y, avg_ground_pos + body_height, 0.1)
