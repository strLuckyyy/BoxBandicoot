extends Control

@export var stamina_node: Stamina_Node
@export var mesh: MeshInstance3D

@onready var text_edit: TextEdit = $ColorRect/TextEdit
@onready var mesh_text: TextEdit = $ColorRect2/TextEdit

var last_stamina = 0
var last_mesh = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UI_Update_Form
	last_stamina = stamina_node.get_current_energy()
	text_edit.text = "Stamina: " + str(stamina_node._current_energy)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if last_stamina != stamina_node._current_energy:
		update_stamina_UI()
	UI_Update_Form()
	
func update_stamina_UI():
	last_stamina = stamina_node._current_energy
	text_edit.text = "Stamina: " + str(stamina_node._current_energy)

func UI_Update_Form():
	if mesh.mesh.to_string().contains("BoxMesh"):
			mesh_text.text = "Type: Box" 
		
	elif mesh.mesh.to_string().contains("SphereMesh"):
		mesh_text.text = "Type: Sphere" 
	
	elif mesh.mesh.to_string().contains("PrismMesh"):
		mesh_text.text = "Type: Prism" 
