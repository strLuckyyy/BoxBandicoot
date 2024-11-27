extends Node3D
class_name Skills_Node


@export var _player: Player
@export var _stamina_node: Stamina_Node
@export var _shape_control: Shape_Control_Node
@export var _camera: Node3D
@export var _sphere_stamina_cost_cooldown: Timer

@onready var _is_box: bool = false
@onready var _is_sphere: bool = false
@onready var _can_waste: bool = true
@onready var _jump_count: int = 0
@onready var _sphere_cost: int = 30
@onready var _y_direction: int = 1
@onready var _z_direction: float = 180
@onready var _prism_state: String = 'isnt_transformed'

const _JUMP_VELOCITY: float = 9.6
const _FALL_VELOCITY: float = 3.2



func _physics_process(delta: float) -> void:
	# Execução da habilidade em esfera. A habilidade funciona enquanto o jogador segura o botão.
	if _is_sphere and _stamina_node.can_waste == true: 
		_player.velocity.y += 0.35
		_sphere_stamina_cost()
	
	elif _prism_state != 'isnt_transformed':
		_player.rotation_degrees.lerp(Vector3(get_rotation().x, get_rotation().y, _z_direction), 0.2 * delta) # = _z_direction
		_gravity(delta)
	
	elif not _player.is_on_floor(): _gravity(delta)


## Getter
func get_is_prism_skill_active() -> bool:
	if _prism_state == 'on': return true
	return false

## Setters. Use-os se necessário.
func set_z_direction(new_z_dir: float) -> void: _z_direction = new_z_dir
func set_y_direction(new_y_dir: int) -> void: _y_direction = new_y_dir
func set_sphere_waste_cooldown(new_cd: float): _sphere_stamina_cost_cooldown.set_wait_time(new_cd)
func set_jump_count(new_count: int): _jump_count = new_count


## Método que deve ser chamado quando for usar alguma habilidade. Esse método "lê"
## a Mesh do objeto e verifica qual mesh está selecionada. Com base nisso, ele executa
## a habilidade correspondente.
func use_skill() -> void:
	if _shape_control.check_current_shape("Box"): _box_shape_skill()
	if _shape_control.check_current_shape("Sphere"): _sphere_shape_skill()
	if _shape_control.check_current_shape("Prism"): _prism_shape_skill()


## Chamar para quando o jogador soltar o botão de skill.
func realese_button_skill() -> void:
	_is_sphere = false


func _gravity(delta: float) -> void: 
	_player.velocity += _player.get_gravity() * delta * (_y_direction)


## Não chamar esse método! Use "use_skill" ao invés disso.
func _box_shape_skill() -> void:
	# Pulo.
	if _player.is_on_floor():
		_player.velocity.y = _JUMP_VELOCITY
		_jump_count += 1
	
	# Se tacando no chão caso esteja no ar.
	elif _jump_count >= 1 and !_player.is_on_floor():
		_player.velocity.y = _JUMP_VELOCITY * (-_FALL_VELOCITY)
		_jump_count = 0


## Não chamar esse método! Use "use_skill" ao invés disso.
func _sphere_shape_skill() -> void:
	if _stamina_node.get_current_energy() >= _sphere_cost:
		_is_sphere = true


## Não chamar esse método! Ele gasta a energia do player por um tempo X sempre que for chamado.
func _sphere_stamina_cost() -> void:
	if _can_waste == false: return 
	
	_stamina_node.waste(_sphere_cost)
	_sphere_stamina_cost_cooldown.start(_sphere_stamina_cost_cooldown.get_wait_time())
	_can_waste = false


## Não chamar esse método! Use "use_skill" ao invés disso.
func _prism_shape_skill() -> void:
	const states: Array[String] = ['off', 'on', 'isnt_transformed']
	
	# Definindo o prism state
	if _prism_state == states[2]: _prism_state = states[1]
	else: _prism_state = states[0] if _prism_state == states[1] else states[1]
	
	_y_direction = 1 if _y_direction == -1 else -1
	_z_direction = 180 if _player.rotation_degrees.z == 0 else 0
	
	#_stamina_node.waste(30)


func _on_sphere_stamina_timeout() -> void:
	_sphere_stamina_cost_cooldown.stop()
	_can_waste = true
