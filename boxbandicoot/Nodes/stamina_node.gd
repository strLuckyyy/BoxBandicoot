extends Node3D
class_name Stamina_Node

@export var recover_timer: Timer
@export var tired_timer: Timer

const MAX_ENERGY: int = 100
var current_energy: int
var is_tired: bool
var can_waste: bool
var is_timer_over: bool


func _ready() -> void:
	current_energy = MAX_ENERGY
	
	is_tired = false
	can_waste = true
	is_timer_over = true


func _physics_process(_delta: float) -> void:
	
	## Operadores ternários, basicamente se a stamina zerar o player fica cansado,
	# e não pode gastar energia. Além de garantir energia que a energia não fique
	# abaixo de 0.
	current_energy = 0 if current_energy <= 0 else current_energy
	can_waste = false if current_energy <= 0 else true
	is_tired = true if current_energy <= 0 else false
	
	_tired_state() 
	_recover()


# Chame esse método quando o player for "gastar" energia.
func waste(value: int) -> void:
	if can_waste == false: return
	
	current_energy -= value


# Chame esse método quando alguma coisa recuperar um valor X da energia do player.
func recover_with_value(value: int) -> void: 
	if current_energy == MAX_ENERGY: return
	
	current_energy += value


## Não chame esse método, ele já é chamado a todo momento.
# Recupera a vida a cada X tempo. Esse valor X deve ser mudado pelo Node RecoverTimer em si.
func _recover() -> void:
	if is_timer_over == false: return
	if can_waste == false: return
	if is_tired == true: return
	
	if current_energy < MAX_ENERGY: 
		current_energy += 1
		recover_timer.start(recover_timer.get_wait_time())
		is_timer_over = false


## Não chame esse método, ele já é chamado a todo momento.
# Inicia o timer para sair do estado "tired". Esse estado impede a recarga de 
# energia por um periodo de tempo X. Esse valor X deve ser mudado pelo Node TiredTimer em si.
func _tired_state() -> void: 
	if is_timer_over == false: return
	if is_tired == false: return
	
	recover_timer.stop() # Evitando que o timer rode sem motivo.
	tired_timer.start(tired_timer.get_wait_time())
	is_timer_over = false


func _on_recover_timer_timeout() -> void:
	recover_timer.stop() # Evitando que o timer rode sem motivo.
	is_timer_over = true


func _on_tired_timer_timeout() -> void:
	tired_timer.stop() # Evitando que o timer rode sem motivo.
	current_energy = 1
	is_timer_over = true
