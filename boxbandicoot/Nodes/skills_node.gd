extends Node3D
class_name Skills_Node

@export var _current_mesh: MeshInstance3D
@export var _player: CharacterBody3D
@export var _stamina_node: Stamina_Node
@export var _sphere_stamina_cost_cooldown: Timer

@onready var _can_waste: bool = true
@onready var _jump_count: int = 0
@onready var y_direction: int = 1
@onready var z_direction: float = 180

const _JUMP_VELOCITY: float = 9.6
const _FALL_VELOCITY: float = 2.5
var _is_box: bool = false
var is_prism: bool = false
var _is_sphere: bool = false


func _ready() -> void:
	_checking_mesh("BoxMesh", true, false, false)
	_checking_mesh("PrismMesh", false, true, false)
	_checking_mesh("SphereMesh", false, false, true)


func _physics_process(delta: float) -> void:
	# Execução da habilidade em esfera. A habilidade funciona enquanto o jogador segura o botão.
	if _is_sphere and _stamina_node.can_waste == true: _player.velocity.y += 0.35
	elif not _player.is_on_floor(): _gravity(delta) 
	
	# Execução da habilidade em prisma. Literalmente, inverte a gravidade.
	if is_prism: 
		_current_mesh.rotation_degrees.z = z_direction
		_gravity(delta)
	elif not _player.is_on_floor(): _gravity(delta)


## Método que deve ser chamado quando for usar alguma habilidade. Esse método "lê"
## a Mesh do objeto e verifica qual mesh está selecionada. Com base nisso, ele executa
## a habilidade correspondente.
func use_skill() -> void:
	if _current_mesh.mesh.to_string().contains("BoxMesh"):
		_box_shape_skill()
		
	if _current_mesh.mesh.to_string().contains("SphereMesh"):
		_sphere_shape_skill()
		
	if _current_mesh.mesh.to_string().contains("PrismMesh"):
		_prism_shape_skill()


## Chamar para quando o jogador soltar o botão de skill. Na prática, só vai afetar a Esfera.
func realese_button_skill() -> void: _is_sphere = false


func _gravity(delta: float) -> void: 
	_player.velocity += _player.get_gravity() * delta * (y_direction)


## Não chamar esse método! Use "use_skill" ao invés disso.
func _box_shape_skill() -> void:
	# Pulo.
	if _player.is_on_floor():
		_player.velocity.y = _JUMP_VELOCITY
		_stamina_node.waste(15)
		_jump_count += 1
	
	# Se tacando no chão caso esteja no ar.
	elif _jump_count == 1 and !_player.is_on_floor():
		_player.velocity.y = _JUMP_VELOCITY * (-_FALL_VELOCITY)
		_stamina_node.waste(5)
		_jump_count = 0


## Não chamar esse método! Use "use_skill" ao invés disso.
func _sphere_shape_skill() -> void:
	_is_sphere = true
	
	if _can_waste == false: return 
	
	_stamina_node.waste(25)
	_sphere_stamina_cost_cooldown.start(_sphere_stamina_cost_cooldown.get_wait_time())
	_can_waste = false


## Não chamar esse método! Use "use_skill" ao invés disso.
func _prism_shape_skill() -> void:
	is_prism = true
	y_direction = 1 if y_direction == -1 else -1
	z_direction = 180 if _current_mesh.rotation_degrees.z == 0 else 0
	
	_stamina_node.waste(30)


## Encapsulando e dizendo para o jogo com que mesh o jogo iniciou.
func _checking_mesh(mesh_name: String, box_value: bool, prism_value: bool, sphere_value: bool) -> void:
	if _current_mesh.mesh.to_string().contains(mesh_name):
		_is_box = box_value
		is_prism = prism_value
		_is_sphere = sphere_value


func _on_sphere_stamina_timeout() -> void:
	_sphere_stamina_cost_cooldown.stop()
	_can_waste = true
