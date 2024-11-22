extends Area3D
class_name Forced_Shape_Area

@export var _shape_control_node: Shape_Control_Node
@export var _shape_name: String 

@onready var _is_inside: bool = false
@onready var _internal_shape_name: String = ''


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_shape_control_node.set_shape_lock(_internal_shape_name)


func _on_body_entered(body: Node3D) -> void:
	_is_inside = true
	_internal_shape_name = _shape_name


func _on_body_exited(body: Node3D) -> void:
	_is_inside = false
	_internal_shape_name = ''
