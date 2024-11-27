extends Control
@onready var sart_game: Button = $Sart_Game
@onready var quit_game: Button = $Quit_Game
@export var first_level = ""


func _on_sart_game_pressed() -> void:
	get_tree().change_scene_to_file('res://main_map.tscn')
	#Adicione o caminho do primeiro nivel no exporte ao lado 


func _on_quit_game_pressed() -> void:
	get_tree().quit()
