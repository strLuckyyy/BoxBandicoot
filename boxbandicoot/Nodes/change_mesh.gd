extends Node3D

## Não precisa chamar nenhum método dessa classe para ela funcionar. Apenas coloque ela no Nó do 
## player e conecte as variáveis necessárias.
class_name Change_Node

@export var _player: Player
@export var _player_mesh: MeshInstance3D
@export var _box_material: Material
@export var _prism_material: Material
@export var _sphere_material: Material
@export var _skills_node: Skills_Node
#@export var _stamina_node: Stamina_Node

@onready var _can_transform: bool = true
@onready var _box_mesh: BoxMesh = BoxMesh.new()
@onready var _prism_mesh: PrismMesh = PrismMesh.new()
@onready var _sphere_mesh: SphereMesh = SphereMesh.new()

var _is_box: bool = false
var _is_sphere: bool = false
var _is_prism: bool = false


func _ready() -> void:
	_update_current_mesh()


func _physics_process(_delta: float) -> void:
	_update_current_mesh()
	_change_mesh()
	
	print(_is_prism)


func lock_shape(can_transform: bool, mesh_name: String) -> void:
	_can_transform = can_transform
	
	if mesh_name.contains('Box'): _transfom(_box_mesh)
	if mesh_name.contains('Prism'): _transform_mesh(_prism_mesh)
	if mesh_name.contains('Sphere'): _transfom(_sphere_mesh)


## Método responsável por transformar o player em alguma forma com base no Input do mesmo.
func _change_mesh() -> void:	
	if Input.is_action_just_pressed("TransformToBox"):
		if _can_transform == false: return
		if _is_box == true: return
		if !_player.is_on_floor(): _skills_node.set_jump_count(1)
		
		_transfom(_box_mesh)
	
	if Input.is_action_just_pressed("TransformToSphere"):
		if _can_transform == false: return
		if _is_sphere == true: return
		_transfom(_sphere_mesh)
	
	if Input.is_action_just_pressed("TransformToPrism"):
		if _can_transform == false: return
		if _is_prism == true: return
		_transform_mesh(_prism_mesh)


## Encapsulando para evitar repetição.
func _transfom(mesh: Mesh):
	_skills_node.set_y_direction(1)
	_skills_node.set_is_prism(false)
	
	_transform_mesh(mesh)


## Encapsulando para evitar repetição. Aqui muda a mesh e o material do objeto.
func _transform_mesh(mesh: Mesh) -> void:
	_player_mesh.set_mesh(mesh)
	_update_current_mesh()
	
	_player_mesh.mesh.set_material(_setting_material())
	#_stamina_node.waste(20)


## Evitar do objeto se transformar nele mesmo.
func _update_current_mesh() -> void:
	# Checando Box State
	_setting_mesh("Box", true, false, false)
	
	# Checando Prism State
	_setting_mesh("Prism", false, true, false)
	
	# Checando Sphere State
	_setting_mesh("Sphere", false, false, true)


## Encapsulando para evitar repetição. Esse método define as variáveis booleanas para o funcionamento
## do sistema.
func _setting_mesh(mesh_name: String, box_value: bool, prism_value: bool, sphere_value: bool) -> void:
	if _player_mesh.mesh.to_string().contains(mesh_name):
		_is_box = box_value
		_is_prism = prism_value
		_is_sphere = sphere_value


## Retorna o material correspondente à malha atual.
func _setting_material() -> Material:
	if _is_box: return _box_material
	if _is_prism: return _prism_material
	return _sphere_material


## Muda o collision do objeto com base na mesh. No momento não há shape para o Prism.
## Ainda não implementado.
func _setting_collision_shape() -> Shape3D:
	if _is_sphere: return SphereShape3D.new()
	return BoxShape3D.new()
