extends GridContainer

@export var pm_images: Array[CompressedTexture2D]
var user_art_gallery_container := preload("user_art_gallery_container.tscn")
@onready var global_vars := get_node("/root/GlobalVariables")

func _ready():
	var _display_array := []
	for _i in range(0, 18):
		if randf() < 0.4:
			_display_array.append({"tex"=pm_images[randi() % pm_images.size()], "priced"= true})
		else:
			var _tmp_image = Image.create(48, 72, false, Image.FORMAT_RGBA8)
			_tmp_image.fill(Color.WHITE)
			var _tmp_texture = ImageTexture.create_from_image(_tmp_image)
			_display_array.append({"tex" = _tmp_texture, "priced" = false})
	_display_array.shuffle()
	for display_texture in _display_array:
		var _tmp := user_art_gallery_container.instantiate()
		var _tmp_u_art_tex_rect := _tmp.get_node("ColorRect/Rect/UserArt")
		_tmp_u_art_tex_rect.texture = display_texture["tex"]
		var _tmp_price := _tmp.get_node("ColorRect/Rect/Price")
		if(display_texture["priced"]):
			var _price := randi_range(1500, 10000)
			var _str_format := "${p}"
			_tmp_price.text = _str_format.format({"p": _price})
		else:
			_tmp_price.hide()
		add_child(_tmp)
