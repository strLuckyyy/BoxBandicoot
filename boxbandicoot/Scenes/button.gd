extends StaticBody3D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name != "ButtonCollision":
		anim.play("PressDown")
		print("Pressed")


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name != "ButtonCollision":
		anim.play("PressUp")
		print("Released")
