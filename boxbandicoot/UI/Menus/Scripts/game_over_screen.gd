extends Control
@onready var button: Button = $Button
@export var main_menu = ""

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file('main_menu')
	#Adicione o caminho da cena do menu no inspetor
