extends Area3D
class_name ButtonControl


@export var _button_type: String = 'Box'
@export var _current_door: DoorNode

@onready var _box_button: Node3D = $CollisionShape3D/box_button
@onready var _sphere_button: Node3D = $CollisionShape3D/sphere_button
@onready var _prism_button: Node3D = $CollisionShape3D/prism_button

@onready var _is_inside: bool = false

var _player_body: Player

func _ready() -> void:
	_check_button('Box', true, false, false)
	_check_button('Sphere', false, true, false)
	_check_button('Prism', false, false, true)


func _physics_process(delta: float) -> void:
	if not _is_inside: return
	
	if _player_body.shape_control.check_current_shape(_button_type):
		if _current_door == null: return
		_current_door.open_door()


func _check_button(button_name: String, box_value: bool, sphere_value: bool, prism_value: bool) -> void:
		if _button_type.contains(button_name):
			_box_button.set_visible(box_value)
			_sphere_button.set_visible(sphere_value)
			_prism_button.set_visible(prism_value)


func _on_body_entered(body: Player) -> void:
	_player_body = body
	_is_inside = true


func _on_body_exited(body: Player) -> void:
	_is_inside = false
