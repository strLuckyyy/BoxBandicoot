extends Node3D

@export var stam: Stamina_Node
@export var shape_control: Shape_Control_Node
@onready var neck_yaw: Node3D = $Neck_yaw
@onready var neck_pitch: Node3D = $"Neck_yaw/Neck pitch"
@onready var camera_3d: Camera3D = $"Neck_yaw/Neck pitch/SpringArm3D/Camera3D"
@onready var spring_arm_3d: SpringArm3D = $"Neck_yaw/Neck pitch/SpringArm3D"

@onready var animation_player: AnimationPlayer = $"Neck_yaw/Neck pitch/SpringArm3D/Camera3D/AnimationPlayer"

var upside_down = false

var yaw = 0.0
var pitch = 0.0

var yaw_sense = 0.07
var pitch_sense = 0.07

var yaw_accel = 15.0
var pitch_accel = 15.0

var min_pitch = -60
var max_pitch = 30


func _input(event: InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw += event.relative.x * yaw_sense
		pitch += event.relative.y * pitch_sense
		
func _physics_process(delta: float):
	
	if Input.is_action_just_pressed("Skill") and shape_control.get_is_prism():
			camera_roll(delta)
		
	pitch = clamp(pitch,min_pitch, max_pitch)
	
	neck_yaw.rotation_degrees.y = yaw
	neck_pitch.rotation_degrees.x = pitch

func camera_roll(delta):
	if upside_down == false:
		spring_arm_3d.position.y = -1.689
		animation_player.play("Rotate_upside_down")
		#camera_3d.rotation_degrees.z = 180
		upside_down = true
		
	else:
		spring_arm_3d.position.y = 1.689
		animation_player.play("Rotate_back")
	#	camera_3d.rotation_degrees.z = 0
		upside_down = false
	
