extends Node3D

@onready var neck_yaw: Node3D = $Neck_yaw
@onready var neck_pitch: Node3D = $"Neck_yaw/Neck pitch"
@onready var camera_3d: Camera3D = $"Neck_yaw/Neck pitch/SpringArm3D/Camera3D"

var yaw = 0.0
var pitch = 0.0

var yaw_sense = 0.07
var pitch_sense = 0.07

var yaw_accel = 15.0
var pitch_accel = 15.0

var min_pitch = -60
var max_pitch = 30


func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * yaw_sense
		pitch -= event.relative.y * pitch_sense
		
func _physics_process(_delta: float):
	#print(pitch)
	pitch = clamp(pitch,min_pitch, max_pitch)
	
	neck_yaw.rotation_degrees.y = yaw
	neck_pitch.rotation_degrees.x = pitch
