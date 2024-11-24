extends Area3D
class_name Forced_Shape_Area

@export var _shape_control_node: Shape_Control_Node
@export var _can_become_box: bool = true
@export var _can_become_sphere: bool = false
@export var _can_become_prism: bool = false

@onready var _is_inside: bool = false
@onready var _shape_name_list: Array[String] = ['Box', 'Sphere', 'Prism']
@onready var _shape_name: String = ''

var _internal_values: Array[int] = [0, 0, 0]


func _ready() -> void:
	if _can_become_box: 
		_internal_values[0] = 1
		_shape_name = _shape_name_list[0]
		
	if _can_become_sphere: 
		_internal_values[1] = 1
		_shape_name = _shape_name_list[1]
		
	if _can_become_prism: 
		_internal_values[2] = 1
		_shape_name = _shape_name_list[2]


func _sum_array(array) -> int:
	var sum = 0.0
	for element in array: sum += element
	return sum


func _on_body_entered(body: Node3D) -> void:
	_is_inside = true
	if _sum_array(_internal_values) == 1: 
		_shape_control_node.set_shape_lock(_shape_name)
	elif _sum_array(_internal_values) > 1: 
		_shape_control_node.set_double_lock(_can_become_box, _can_become_sphere, _can_become_prism)


func _on_body_exited(body: Node3D) -> void:
	_is_inside = false
	_shape_control_node.set_shape_lock()
	_shape_control_node.set_double_lock()
