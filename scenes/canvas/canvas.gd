extends TextureRect

@export var fa_images: Array[CompressedTexture2D]
var color_select_rect := preload("color_select_rect.tscn")
@onready var parent_node := get_parent()
@onready var color_picker_container := parent_node.get_node("ColorPickerContainer")
@onready var check_score_btn := parent_node.get_node("Button")
@onready var check_score_label := parent_node.get_node("Label")
@onready var timer_label := parent_node.get_node("Timer")
@onready var fine_art_node := parent_node.get_node("FineArt")
@onready var fa_downsize := parent_node.get_node("fa_downsize")

@onready var fa_downsize3 := parent_node.get_node("fa_downsize3")
@onready var u_downsize := parent_node.get_node("u_downsize")

@onready var u_downsize3 := parent_node.get_node("u_downsize3")
@onready var global_vars := get_node("/root/GlobalVariables")
@onready var scratch_audio := parent_node.get_node("scratch")

var image := Image.new()
var u_image_downsize := Image.new()

var u_image_downsize3 := Image.new()
var fa_image_downsize := Image.new()

var fa_image_downsize3 := Image.new()
@onready var _size_x: int = fine_art_node.texture.get_image().get_size().x
@onready var _size_y: int = fine_art_node.texture.get_image().get_size().y
var _scale := 20
@onready var canvas_size := Vector2(_size_x, _size_y)
var drawing := false
var time_expired := false
var time_remaining := 120.0

var painting_value := 150

var baseline_score := 0.0
var since_last_diff_update := 0.0
var diff_update_freq := 1.0
var since_last_score_update := 0.0
var score_update_freq := 0.1

var _cheat_enabled := false

func _ready():
	image = Image.create(canvas_size.x as int, canvas_size.y as int, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	texture = ImageTexture.create_from_image(image)

	var fineart = global_vars.get_fineart()
	fine_art_node.texture = fa_images[fineart.index]

	var tmp_csrect0 := color_select_rect.instantiate()
	tmp_csrect0.color = Color.from_string("000000", "000000")
	color_picker_container.add_child(tmp_csrect0)

	var tmp_csrect1 := color_select_rect.instantiate()
	tmp_csrect1.color = Color.from_string("ffffff", "ffffff")
	color_picker_container.add_child(tmp_csrect1)

	for i in range(0, fineart.palette.size()):
		var tmp_csrect := color_select_rect.instantiate()
		tmp_csrect.color = Color.from_string(fineart.palette[i], "000000")
		color_picker_container.add_child(tmp_csrect)

	u_image_downsize = Image.create(canvas_size.x/_scale as int, canvas_size.y/_scale as int, false, Image.FORMAT_RGBA8)
	u_image_downsize.fill(Color.WHITE)
	u_downsize.texture = ImageTexture.create_from_image(u_image_downsize)

	fa_image_downsize = fine_art_node.texture.get_image().duplicate()
	fa_image_downsize.resize(canvas_size.x/_scale as int, canvas_size.y/_scale as int, Image.INTERPOLATE_LANCZOS)
	fa_downsize.texture = ImageTexture.create_from_image(fa_image_downsize)

	_record_baseline()

	u_image_downsize3 = Image.create(canvas_size.x/(_scale/4) as int, canvas_size.y/(_scale/4) as int, false, Image.FORMAT_RGBA8)
	u_image_downsize3.fill(Color.WHITE)
	u_downsize3.texture = ImageTexture.create_from_image(u_image_downsize3)

	if(_cheat_enabled):
		var fa_img: Image = fa_image_downsize.duplicate()
		var u_img: Image = u_image_downsize.duplicate()
		for i in range(0, fa_img.get_size().x):
			for j in range(0, fa_img.get_size().y):
				var best_so_far := {"score": _color_score(Color.WHITE, fa_img.get_pixel(i, j)), "color": Color.WHITE}
				for k in range(0, fineart.palette.size()):
					var test_color := Color.from_string(fineart.palette[k], "000000")
					var test_score := _color_score(test_color, fa_img.get_pixel(i, j))
					if(test_score < best_so_far["score"]):
						best_so_far["score"] = test_score
						best_so_far["color"] = test_color
				u_img.set_pixel(i, j, best_so_far["color"])
		u_image_downsize = u_img.duplicate()
		var u_img3 := u_img.duplicate()
		u_img3.resize(canvas_size.x/(_scale/4) as int, canvas_size.y/(_scale/4) as int, Image.INTERPOLATE_NEAREST)
		u_image_downsize3 = u_img3
		u_downsize3.texture = ImageTexture.create_from_image(u_image_downsize3)
		u_img.resize(canvas_size.x as int, canvas_size.y as int, Image.INTERPOLATE_NEAREST)
		image = u_img
		texture = ImageTexture.create_from_image(image)
		global_vars._add_user_art(null, u_image_downsize3)

	global_vars.last_fa_image = fine_art_node.texture.get_image().duplicate()

	global_vars.last_scaled_fa_image = fa_image_downsize.duplicate()

	fa_image_downsize3 = fine_art_node.texture.get_image().duplicate()
	fa_image_downsize3.resize(fa_downsize3.size.x, fa_downsize3.size.y, Image.INTERPOLATE_LANCZOS)
	fa_downsize3.texture = ImageTexture.create_from_image(fa_image_downsize3)

	check_score_btn.pressed.connect(self._check_score_btn_pressed)
	global_vars.last_u_image = image.duplicate()



func _process(delta):
	since_last_diff_update += delta
	since_last_score_update += delta
	if(since_last_score_update >= score_update_freq):
		var current_score = _current_score()
		var score_format_string = "Your payout: $%*.*f"
		# Pad to length of 4, round to 3 decimal places:
		check_score_label.text = score_format_string % [5, 2, clamp((1 - (current_score/baseline_score)), 0, 1) * painting_value]
		since_last_score_update = 0.0
		global_vars.current_score_string = score_format_string % [5, 2, clamp((1 - (current_score/baseline_score)), 0, 1) * painting_value]
	if(since_last_diff_update >= diff_update_freq):
		global_vars.last_ufa_diff_image = _diff_scaled_ufa_image().duplicate()
		since_last_diff_update = 0.0

	time_remaining -= delta
	if(time_remaining <= 0 and not time_expired):
		time_remaining = 0.0
		time_expired = true
		timer_label.text = "Time Expired!"
	elif(not time_expired):
		var time_format_string = "Remaining time: %*.*f"
		timer_label.text = time_format_string % [3, 1, time_remaining]



func _record_baseline():
	var fa_img: Image = fa_image_downsize.duplicate()
	var u_img: Image = u_image_downsize.duplicate()
	if(u_img.get_size().x != fa_img.get_size().x || u_img.get_size().y != fa_img.get_size().y):
		print("Err: u_img and fa_img differ ", u_img.get_size().x, ", ", u_img.get_size().y, ", ", fa_img.get_size().x, ", ", fa_img.get_size().y)
	for i in range(0, fa_img.get_size().x):
		for j in range(0, fa_img.get_size().y):
			var fa_pxl := fa_img.get_pixel(i, j)
			var u_pxl := u_img.get_pixel(i, j)
			baseline_score += _color_score(fa_pxl, u_pxl)

func _check_score_btn_pressed():
	var composite_img = _diff_ufa_image()
	texture = ImageTexture.create_from_image(composite_img)

func _diff_ufa_image() -> Image:
	var fa_img: Image = fine_art_node.texture.get_image()
	var u_img: Image = image.duplicate()
	var composite_img = Image.create(canvas_size.x as int, canvas_size.y as int, false, Image.FORMAT_RGBA8)
	for i in range(0, fa_img.get_size().x):
		for j in range(0, fa_img.get_size().y):
			var fa_pxl := fa_img.get_pixel(i, j)
			var u_pxl := u_img.get_pixel(i, j)
			var tmp_color := Color(
				absf(fa_pxl.r-u_pxl.r),
				absf(fa_pxl.g-u_pxl.g),
				absf(fa_pxl.b-u_pxl.b),
				1.0
			)
			composite_img.set_pixel(i, j, tmp_color)
	return composite_img

func _diff_scaled_ufa_image() -> Image:
	var fa_img: Image = fa_image_downsize.duplicate()
	var u_img: Image = u_image_downsize.duplicate()
	var composite_img = Image.create(fa_img.get_size().x as int, fa_img.get_size().y as int, false, Image.FORMAT_RGBA8)
	for i in range(0, fa_img.get_size().x):
		for j in range(0, fa_img.get_size().y):
			var fa_pxl := fa_img.get_pixel(i, j)
			var u_pxl := u_img.get_pixel(i, j)
			var tmp_color := Color(
				absf(fa_pxl.r-u_pxl.r),
				absf(fa_pxl.g-u_pxl.g),
				absf(fa_pxl.b-u_pxl.b),
				1.0
			)
			composite_img.set_pixel(i, j, tmp_color)
	return composite_img

func _current_score()->float:
	var current_score = 0.0
	var fa_img: Image = fa_image_downsize.duplicate()
	var u_img: Image = u_image_downsize.duplicate()
	for i in range(0, fa_img.get_size().x):
		for j in range(0, fa_img.get_size().y):
			var fa_pxl := fa_img.get_pixel(i, j)
			var u_pxl := u_img.get_pixel(i, j)
			current_score += _color_score(fa_pxl, u_pxl)
	return current_score

func _color_score(a: Color, b: Color) -> float:
	return absf(a.r-b.r) + absf(a.g-b.g) + absf(a.b-b.b)

func _gui_input(event):
	if not time_expired:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				# print("I've been clicked : position: ", event.position, " uds1 pos: ", event.position/_scale, " uds2 pos: ", event.position/(_scale/2))
				if event.pressed:
					drawing = true
					if _event_in_bounds(event):
						u_image_downsize.set_pixelv(event.position/_scale, global_vars.current_color)
						u_downsize.texture.update(u_image_downsize)

						# u_image_downsize2.fill_rect(_pos_to_rect(event.position/(_scale/2), 2), global_vars.current_color)
						# u_downsize2.texture.update(u_image_downsize2)

						u_image_downsize3.fill_rect(_pos_to_rect(event.position/(_scale/4), 4), global_vars.current_color)
						u_downsize3.texture.update(u_image_downsize3)

						image.fill_rect(_pos_to_rect(event.position, _scale), global_vars.current_color)
						texture.update(image)
						global_vars.last_u_image = image.duplicate()
						scratch_audio.play()
				else:
					drawing = false
		if event is InputEventMouseMotion and event.button_mask == MOUSE_BUTTON_LEFT and drawing:
			# print("motion", event)
			if _event_in_bounds(event):
				u_image_downsize.set_pixelv(event.position/_scale, global_vars.current_color)
				u_downsize.texture.update(u_image_downsize)

				# u_image_downsize2.fill_rect(_pos_to_rect(event.position/(_scale/2), 2), global_vars.current_color)
				# u_downsize2.texture.update(u_image_downsize2)

				u_image_downsize3.fill_rect(_pos_to_rect(event.position/(_scale/4), 4), global_vars.current_color)
				u_downsize3.texture.update(u_image_downsize3)

				image.fill_rect(_pos_to_rect(event.position, _scale), global_vars.current_color)
				texture.update(image)
				global_vars.last_u_image = image.duplicate()

func _event_in_bounds(event)->bool:
	return event.position.x >= 0 and event.position.x < canvas_size.x and event.position.y >= 0 and event.position.y < canvas_size.y

func _pos_to_rect(pos: Vector2, scalefactor: int) -> Rect2:
	var pos_x := (pos.x as int / scalefactor) * scalefactor
	var pos_y := (pos.y as int / scalefactor) * scalefactor
	return Rect2(pos_x, pos_y, scalefactor, scalefactor)


func _done_pressed():
	global_vars.total_score += (1 - (_current_score()/baseline_score)) * painting_value
	global_vars._add_user_art(null, u_image_downsize3)
