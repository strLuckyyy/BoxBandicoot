extends CSGBox3D

class_name DoorNode

func open_door() -> void: 
	$".".queue_free()
