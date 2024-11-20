extends Area3D
class_name Forced_Shape_Area

@export var change_mesh_node: Change_Node
@export var _shape_name: String 

@onready var is_inside: bool = false
@onready var _internal_shape_name: String = ''


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_mesh_node.lock_shape(!is_inside, _internal_shape_name)


func _on_body_entered(body: Node3D) -> void:
	is_inside = true
	_internal_shape_name = _shape_name


func _on_body_exited(body: Node3D) -> void:
	is_inside = false
	_internal_shape_name = ''
