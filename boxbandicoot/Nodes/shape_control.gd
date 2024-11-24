extends Node3D
class_name Shape_Control_Node

@export var _player: Player
@export var _box_node: Node3D
@export var _prism_node: Node3D
@export var _sphere_node: Node3D
@export var _skills_node: Skills_Node

@onready var _player_collision: CollisionShape3D = $"../CollisionShape3D"
@onready var _player_obj: Node3D = $"../CollisionShape3D/OBJ"
@onready var _animation: AnimationPlayer = $"../CollisionShape3D/OBJ/AnimationPlayer"

var _is_lock: bool
var _is_box: bool
var _is_prism: bool
var _is_sphere: bool
var _double_lock: Array[bool] = [true, true, true] # 0 = box, 1 = sphere, 2 = prism


func _ready() -> void:
	_is_lock = false
	change_appearance_to('Box')

## Getters e Setters. Use-os, se precisar de mais adicione.
func get_player_collision() -> CollisionShape3D: return _player_collision
func get_player_obj() -> Node3D: return _player_obj
func get_is_lock() -> bool: return _is_lock

func set_shape_lock(shape: String = '') -> void:
	if shape == '': 
		_is_lock = false
		return
	
	change_appearance_to(shape)
	_is_lock = true
func set_on_move(on_move: bool) -> void:
	if on_move: _animation.play('Take 001')
	else: _animation.stop()
func set_double_lock(value_box: bool = true, value_sphere: bool = true, value_prism: bool = true) -> void:
	_double_lock = [value_box, value_sphere, value_prism]


# Métodos Publicos
## Esse método retorna um valor booleano sobre o shape atual do player.
## Para usa-lo, coloque no parametro "shape" o nome do shape que você queira verificar.
func check_current_shape(shape: String = 'Box') -> bool:
	if _box_node.is_visible() and shape.contains('Box'): 
		_switch_bool_values(true, false, false); return true
	elif _prism_node.is_visible() and shape.contains('Prism'):
		_switch_bool_values(false, true, false); return true
	elif _sphere_node.is_visible() and shape.contains('Sphere'):
		_switch_bool_values(false, false, true); return true
	else: return false


## Usado para mudar o shape atual do player.
## Para usa-lo, coloque no parametro "shape" o nome do shape que deseja se transformar.
func change_appearance_to(shape: String) -> void:
	if _is_lock == true: return
	
	if !_is_box and !_player.is_on_floor(): _skills_node.set_jump_count(1)
	
	if _is_prism:
		_skills_node.set_y_direction(1)
		_skills_node.set_z_direction(0)
	
	if check_current_shape(shape): return
	
	_switch_visibility_values(shape)


## Métodos Privados
func _switch_bool_values(box: bool, prism: bool, sphere: bool) -> void:
	_is_box = box
	_is_prism = prism
	_is_sphere = sphere


func _switch_visibility_values(shape: String) -> void:
	var box: bool
	var prism: bool
	var sphere: bool
	
	if shape.contains('Box'):
		if _double_lock[0] == false: return
		box = true
		prism = false
		sphere = false
	
	elif shape.contains('Sphere'):
		if _double_lock[1] == false: return
		box = false
		prism = false
		sphere = true
	
	elif shape.contains('Prism'):
		if _double_lock[2] == false: return
		box = false
		prism = true
		sphere = false
	else: 
		print('Shape doesnt contain any shape name.')
		return
	
	_switch_bool_values(box, prism, sphere)
	
	_box_node.set_visible(box)
	_prism_node.set_visible(prism)
	_sphere_node.set_visible(sphere)


''' #debug
func _is_what() -> void:
	if _is_box: print('box')
	if _is_prism: print('prism')
	if _is_sphere: print('sphere')
'''
