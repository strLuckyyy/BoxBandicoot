extends CharacterBody3D

@export var mouse_sense = 0.01
@export var stamina_node: Stamina_Node
@onready var camera_3d: Camera3D = $"Camera_root/Neck_yaw/Neck pitch/SpringArm3D/Camera3D"
@onready var neck_yaw: Node3D = $Camera_root/Neck_yaw
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var camera_root: Node3D = $Camera_root

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var twist_input = 0
var pitch_input = 0
var is_paused = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float):
	
	if is_paused == true:
		if Input.is_action_just_pressed("Esc"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
			is_paused = false
	else:
		if Input.is_action_just_pressed("Esc"): 
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			is_paused = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() and stamina_node.can_waste == true:
		stamina_node.waste(70)
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction = (neck_yaw.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		collision_shape_3d.rotation_degrees.y = lerp(neck_yaw.rotation_degrees.y, camera_root.yaw, camera_root.yaw_accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	move_and_slide()
"""
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sense
			pitch_input = -event.relative.y * mouse_sense
"""
