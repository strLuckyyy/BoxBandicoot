extends Control
@export var player: Player
@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.is_paused == true:
		self.visible = true
		self.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		self.mouse_filter = Control.MOUSE_FILTER_IGNORE
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		self.visible = false
	
func _on_button_pressed():
	player.is_paused = false
