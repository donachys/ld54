extends Control

@onready var global_vars := get_node("/root/GlobalVariables")
@onready var originals_container := get_node("OriginalsHBoxContainer")
@onready var diff_container := get_node("DifferenceHBoxContainer")
@onready var original_tex_rect := get_node("OriginalsHBoxContainer/Original")
@onready var user_tex_rect := get_node("OriginalsHBoxContainer/User")
@onready var scaled_original_tex_rect := get_node("DifferenceHBoxContainer/ScaledOriginal")
@onready var diff_tex_rect := get_node("DifferenceHBoxContainer/Diff")
@onready var score_label := get_node("ScoreLabel")

var target_rect_size := Vector2i(240, 360)

func _ready():
	var tmp_original_image: Image = global_vars.last_fa_image.duplicate()
	tmp_original_image.resize(target_rect_size.x, target_rect_size.y, Image.INTERPOLATE_LANCZOS)
	original_tex_rect.texture = ImageTexture.create_from_image(tmp_original_image)

	var tmp_user_image: Image = global_vars.last_u_image.duplicate()
	tmp_user_image.resize(target_rect_size.x, target_rect_size.y, Image.INTERPOLATE_LANCZOS)
	user_tex_rect.texture = ImageTexture.create_from_image(tmp_user_image)

	var tmp_original_scaled_image: Image = global_vars.last_scaled_fa_image.duplicate()
	tmp_original_scaled_image.resize(target_rect_size.x, target_rect_size.y, Image.INTERPOLATE_NEAREST)
	scaled_original_tex_rect.texture = ImageTexture.create_from_image(tmp_original_scaled_image)

	var tmp_diff_image: Image = global_vars.last_ufa_diff_image.duplicate()
	tmp_diff_image.resize(target_rect_size.x, target_rect_size.y, Image.INTERPOLATE_NEAREST)
	diff_tex_rect.texture = ImageTexture.create_from_image(tmp_diff_image)

	score_label.text = "Your Payout " + global_vars.current_score_string


func _on_tab_bar_tab_changed(tab: int):
	if(tab == 0):
		originals_container.show()
		diff_container.hide()
	else:
		originals_container.hide()
		diff_container.show()
