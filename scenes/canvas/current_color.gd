extends ColorRect

@onready var global_vars := get_node("/root/GlobalVariables")

func _ready():
	global_vars.current_color = color

func _process(_delta):
	color = global_vars.current_color
