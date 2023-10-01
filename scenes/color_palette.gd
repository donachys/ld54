extends ColorRect

@onready var global_vars := get_node("/root/GlobalVariables")

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				global_vars.current_color = color
