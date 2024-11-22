extends Control


@export var stamina_node: Stamina_Node
@export var shape_control: Shape_Control_Node

@onready var text_edit: TextEdit = $TextureRect/TextEdit
@onready var Cube_texture_UI: TextureRect = $TextureRect2/TextureRect
@onready var Sphere_texture_UI: TextureRect = $TextureRect2/TextureRect2
@onready var Prism_texture_UI: TextureRect = $TextureRect2/TextureRect3
@onready var shape_lock: TextureRect = $"TextureRect2/Shape lock"

@onready var texture_progress_bar: TextureProgressBar = $TextureRect/TextureProgressBar
@onready var mesh_text: TextEdit = $TextureRect2/TextEdit

var last_stamina = 0
var last_mesh = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UI_Update_Form()
	last_stamina = stamina_node.get_current_energy()
	text_edit.text = "Stamina: " + stamina_node.get_current_energy_str()
	texture_progress_bar.value = stamina_node.get_current_energy()
	Cube_texture_UI.visible = false
	Prism_texture_UI.visible = false
	Sphere_texture_UI.visible = false
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	texture_progress_bar.value = stamina_node.get_current_energy()
	if last_stamina != stamina_node.get_current_energy():
		update_stamina_UI()
	#if (variavel que controla a trava de forma) = true:
	#	shape_lock.visible = true
	#else:
		#shape_lock.visible = false
	UI_Update_Form()
	
func update_stamina_UI():
	last_stamina = stamina_node.get_current_energy()
	text_edit.text = "Stamina: " + stamina_node.get_current_energy_str()

func UI_Update_Form():
	if shape_control.check_current_shape("BoxMesh"):
			Cube_texture_UI.visible = true
			Prism_texture_UI.visible = false
			Sphere_texture_UI.visible = false
			mesh_text.text = "Type: Box" 
		
	elif shape_control.check_current_shape("SphereMesh"):
		Cube_texture_UI.visible = false
		Prism_texture_UI.visible = false
		Sphere_texture_UI.visible = true
		mesh_text.text = "Type: Sphere" 
	
	elif shape_control.check_current_shape("PrismMesh"):
		Cube_texture_UI.visible = false
		Prism_texture_UI.visible = true
		Sphere_texture_UI.visible = false
		mesh_text.text = "Type: Prism" 
