extends CSGBox3D


func _on_area_3d_body_entered(body: Player) -> void:
	get_tree().change_scene_to_file('res://UI/Menus/Scenes/game_over_screen.tscn')
