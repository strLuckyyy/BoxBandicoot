extends Node3D
class_name Stamina_Node

@export var _recover_timer: Timer
@export var _tired_timer: Timer

@onready var _is_tired: bool = false
@onready var _is_timer_over: bool = true
@onready var can_waste: bool = true
@onready var _current_energy: int = _MAX_ENERGY
@onready var _recover_value: int = 8

const _MAX_ENERGY: int = 100


func _physics_process(_delta: float) -> void:
	# Operadores ternários, basicamente se a stamina zerar o player fica cansado,
	# e não pode gastar energia. Além de garantir energia que a energia não fique
	# abaixo de 0 e enm acima do limite.
	_current_energy = _MAX_ENERGY if _current_energy >= _MAX_ENERGY else _current_energy
	_current_energy = 0 if _current_energy <= 0 else _current_energy
	can_waste = false if _current_energy <= 0 else true
	_is_tired = true if _current_energy <= 0 else false
	
	_tired_state() 
	_recover()
	
	#print(_current_energy)


## Chame esse método quando o player for "gastar" energia.
func waste(value: int) -> void:
	if can_waste == false: return
	
	_current_energy -= value


## Chame esse método quando alguma coisa recuperar um valor X da energia do player.
func recover_with_value(value: int) -> void: 
	if _current_energy == _MAX_ENERGY: return
	
	_current_energy += value


## Aqui você setta um novo tempo X de recuperação. Você pode fazer o personagem recuperar mais 
## lentamente ou rapidamente. Tempo em segundos.
func set_recover_cooldown(new_cd: float) -> void:
	_recover_timer.set_wait_time(new_cd)


## Aqui você setta um novo tempo X em que o personagem vai se manter no TiredState. Tempo em segundos.
func set_tired_cooldown(new_cd: float) -> void:
	_tired_timer.set_wait_time(new_cd)


## Não chame esse método, ele já é chamado a todo momento.
## Recupera a vida a cada X tempo. Esse valor X deve ser mudado pelo Node RecoverTimer em si ou pelo set.
func _recover() -> void:
	if _is_timer_over == false: return
	if can_waste == false: return
	if _is_tired == true: return
	
	if _current_energy < _MAX_ENERGY: 
		_current_energy += _recover_value
		_recover_timer.start(_recover_timer.get_wait_time())
		_is_timer_over = false


## Não chame esse método, ele já é chamado a todo momento.
## Inicia o timer para sair do estado "tired". Esse estado impede a recarga de 
## energia por um periodo de tempo X. Esse valor X deve ser mudado pelo Node TiredTimer em si ou pelo set.
func _tired_state() -> void: 
	if _is_timer_over == false: return
	if _is_tired == false: return
	
	_recover_timer.stop() # Evitando que o timer rode sem motivo.
	_tired_timer.start(_tired_timer.get_wait_time())
	_is_timer_over = false


func _on_recover_timer_timeout() -> void:
	_recover_timer.stop() # Evitando que o timer rode sem motivo.
	_is_timer_over = true


func _on_tired_timer_timeout() -> void:
	_tired_timer.stop() # Evitando que o timer rode sem motivo.
	_current_energy = 1
	_is_timer_over = true
