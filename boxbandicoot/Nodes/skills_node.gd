extends Node3D
class_name Skills_Node

@export var _current_mesh: MeshInstance3D
@export var _player: CharacterBody3D
@export var _stamina_node: Stamina_Node
@export var _sphere_stamina_cost_cooldown: Timer

@onready var is_prism: bool = false
@onready var _is_sphere: bool = false
@onready var _can_waste: bool = true
@onready var _jump_count: int = 0
@onready var y_direction: int = 1

const _JUMP_VELOCITY: float = 9.6
const _FALL_VELOCITY: float = 2.5

func _physics_process(delta: float) -> void:
	
	# Execução da habilidade em esfera. A habilidade funciona enquanto o jogador segura o botão.
	if _is_sphere and _stamina_node.can_waste == true: _player.velocity.y += 0.35
	elif not _player.is_on_floor(): _gravity(delta) 
	
	# Execução da habilidade em prisma. Literalmente, inverte a gravidade.
	if is_prism: _gravity(delta)
	elif not _player.is_on_floor(): _gravity(delta)
	
	print(y_direction, is_prism)


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
		#_stamina_node.waste(15)
		_jump_count += 1
	
	# Se tacando no chão caso esteja no ar.
	elif _jump_count == 1 and !_player.is_on_floor():
		_player.velocity.y = _JUMP_VELOCITY * (-_FALL_VELOCITY)
		#_stamina_node.waste(5)
		_jump_count = 0


## Não chamar esse método! Use "use_skill" ao invés disso.
func _sphere_shape_skill() -> void:
	_is_sphere = true
	
	if _can_waste == false: return 
	
	#_stamina_node.waste(25)
	_sphere_stamina_cost_cooldown.start(_sphere_stamina_cost_cooldown.get_wait_time())
	_can_waste = false


## Não chamar esse método! Use "use_skill" ao invés disso.
func _prism_shape_skill() -> void:
	is_prism = true if is_prism == false else false
	y_direction = 1 if y_direction == -1 else -1
	#_stamina_node.waste(30)


func _on_sphere_stamina_timeout() -> void:
	_sphere_stamina_cost_cooldown.stop()
	_can_waste = true
