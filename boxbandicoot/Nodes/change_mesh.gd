extends Node3D

## Não precisa chamar nenhum método dessa classe para ela funcionar. Apenas coloque ela no Nó do 
## player e conecte as variáveis necessárias.
class_name Change_Node

@export var _player: CharacterBody3D
@export var _player_mesh: MeshInstance3D
@export var _box_material: Material
@export var _prism_material: Material
@export var _sphere_material: Material
@export var _skills_node: Skills_Node
#@export var _stamina_node: Stamina_Node

var _is_box: bool = false
var _is_sphere: bool = false
var _is_prism: bool = false


func _ready() -> void:
	_update_current_mesh()
	
	if _is_box: _transform_mesh(BoxMesh)
	if _is_prism: _transform_mesh(PrismMesh)
	if _is_sphere: _transform_mesh(SphereMesh)


func _physics_process(_delta: float) -> void:
	_update_current_mesh()
	_change_mesh()


## Método responsável por transformar o player em alguma forma com base no Input do mesmo.
func _change_mesh() -> void:
	if Input.is_action_just_pressed("TransformToBox"):
		if _is_box == true: return
		if !_player.is_on_floor(): _skills_node.set_jump_count(1)
		
		_skills_node.set_y_direction(1)
		_skills_node.set_is_prism(false)
		
		_transform_mesh(BoxMesh)
	
	if Input.is_action_just_pressed("TransformToSphere"):
		if _is_sphere == true: return
		
		_skills_node.set_y_direction(1)
		_skills_node.set_is_prism(false)
		
		_transform_mesh(SphereMesh)
	
	if Input.is_action_just_pressed("TransformToPrism"):
		if _is_prism == true: return
		
		_transform_mesh(PrismMesh)


## Encapsulando para evitar repetição. Aqui muda a mesh e o material do objeto.
func _transform_mesh(mesh: Object) -> void:
	_player_mesh.set_mesh(mesh.new())
	_update_current_mesh()
	
	_player_mesh.mesh.set_material(_setting_material())
	#_stamina_node.waste(20)


## Evitar do objeto se transformar nele mesmo.
func _update_current_mesh() -> void:
	# Checando Box State
	_setting_mesh("BoxMesh", true, false, false)
	
	# Checando Prism State
	_setting_mesh("PrismMesh", false, true, false)
	
	# Checando Sphere State
	_setting_mesh("SphereMesh", false, false, true)


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
