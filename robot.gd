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
	)
	
	if(movement != Vector2.ZERO):
		movement = movement.normalized()
	
	velocity = movement.length()+rot*delta
	#print(velocity)
	
	var body_heigh_adjustment:float = Input.get_axis("body_down", "body_up")
	body_height += body_heigh_adjustment * 0.05
	
	# Move leg targets
	$Raycasts.global_position = self.global_position - (transform.basis.x*movement.y + transform.basis.z*movement.x) * 3
	
	# movement
	# global_position += -transform.basis.z * speed * delta * movement.x
	# global_position += -transform.basis.x * speed * delta * movement.y
	
	# set body position to average of leg position
	var avg_x = ($Armature/BL_Target.global_position.x + $Armature/BR_Target.global_position.x + $Armature/FL_Target.global_position.x + $Armature/FR_Target.global_position.x)/4
	var avg_z = ($Armature/BL_Target.global_position.z + $Armature/BR_Target.global_position.z + $Armature/FL_Target.global_position.z + $Armature/FR_Target.global_position.z)/4
	
	global_position.x = move_toward(global_position.x, avg_x, 20*delta)
	global_position.z = move_toward(global_position.z, avg_z, 20*delta)
	
	update_body_height(delta)

func update_body_height(delta):
	var avg_ground_pos = ($Armature/BL_Target.global_position.y + $Armature/BR_Target.global_position.y + $Armature/FL_Target.global_position.y + $Armature/FR_Target.global_position.y)/4
	global_position.y = move_toward(global_position.y, avg_ground_pos + body_height, delta*10)
