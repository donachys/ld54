extends Button

signal scene_change_requested(next_scene)

@export var next_scene: String

func _ready():
	pressed.connect(_btn_pressed)

func _btn_pressed():
	get_tree().change_scene_to_file(next_scene)
