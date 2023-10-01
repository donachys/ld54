extends GridContainer

@export var pm_images: Array[CompressedTexture2D]
var user_art_gallery_container := preload("user_art_gallery_container.tscn")
@onready var global_vars := get_node("/root/GlobalVariables")

func _ready():
	var u_arts: Array = global_vars.user_arts.duplicate()
	var u_arts_count := u_arts.size()
	var _display_array := []
	while not u_arts.is_empty():
		var _tmp_u_art: Image = u_arts.pop_front()["u_img"]
		_display_array.append(ImageTexture.create_from_image(_tmp_u_art))
	for _i in range(u_arts_count, 18):
		_display_array.append(pm_images[randi() % pm_images.size()])
	_display_array.shuffle()
	for display_texture in _display_array:
		var _tmp := user_art_gallery_container.instantiate()
		var _tmp_u_art_tex_rect := _tmp.get_node("ColorRect/Rect/UserArt")
		_tmp_u_art_tex_rect.texture = display_texture
		var _price := randi_range(1500, 10000)
		var _tmp_price := _tmp.get_node("ColorRect/Rect/Price")
		var _str_format := "${p}"
		_tmp_price.text = _str_format.format({"p": _price})
		add_child(_tmp)
