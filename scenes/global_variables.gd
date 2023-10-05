extends Node2D

var current_color: Color = Color(0, 0, 0, 0)
var last_fa_image: Image = Image.new()
var last_scaled_fa_image: Image = Image.new()
var last_u_image: Image = Image.new()
var last_ufa_diff_image: Image = Image.new()
var current_score_string: String = "0.0"
var total_score: float = 0.0

var data = {
	fineart = [
		{
			index = 0,
			path = "res://assets/fineart/0001_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"35271D",
				"4C3528",
				"664A32",
				"6B5748",
				"9B6A36",
				"A47445",
				"BE8F41",
				"D8C2B5",
			]
		},
		{
			index = 1,
			path = "res://assets/fineart/0002_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"241D22",
				"332A2A",
				"50483D",
				"5F2229",
				"9A1E28",
				"A2663C",
				"C0965F",
				"DACBAA",
			]
		},
		{
			index = 2,
			path = "res://assets/fineart/0003_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"0E0D07",
				"2F1C15",
				"542D19",
				"665234",
				"95A68F",
				"9C6425",
				"A9753B",
				"CBA14D",
			]
		},
		{
			index = 3,
			path = "res://assets/fineart/0004_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"1A7990",
				"222C22",
				"384842",
				"554F36",
				"5F6254",
				"818C77",
				"9A9867",
				"A6964C",
			]
		},
		{
			index = 4,
			path = "res://assets/fineart/0005_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"2F2531",
				"4C373E",
				"575953",
				"A7734E",
				"AE9A6A",
				"C3BB97",
				"DE9B59",
				"E6D8A2",
			]
		},
		{
			index = 5,
			path = "res://assets/fineart/0006_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"182150",
				"484F59",
				"738183",
				"9BA6A5",
				"ABC0BE",
				"D9D8CB",
				"E3CAA8",
				"EFE9D6",
			]
		},
		{
			index = 6,
			path = "res://assets/fineart/0007_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"0C1013",
				"261D12",
				"4F4138",
				"665F5A",
				"7A6B75",
				"B29173",
				"C2BAAC",
			]
		},
		{
			index = 7,
			path = "res://assets/fineart/0008_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"0B90C7",
				"1476AA",
				"1A1918",
				"3892B0",
				"474849",
				"9E462D",
				"C09F36",
				"C8CAC5",
			]
		},
		{
			index = 8,
			path = "res://assets/fineart/0009_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"241F1D",
				"5F4923",
				"D64038",
				"DBB649",
				"E1A561",
				"E9AE8C",
				"F9DDA4",
			]
		},
		{
			index = 9,
			path = "res://assets/fineart/00010_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"01B6A1",
				"01C0AE",
				"0F8978",
				"2A2826",
				"EE0873",
				"F5D703",
				"FF0082",
			]
		},
		{
			index = 10,
			path = "res://assets/fineart/00011_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"362D20",
				"A21B1B",
				"A76A41",
				"AF010C",
				"B09948",
				"B0ABA8",
				"D5D2D3",
				"FAFAFD",
			]
		},
		{
			index = 11,
			path = "res://assets/fineart/00012_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"203343",
				"374B5B",
				"465868",
				"56646E",
				"8E7768",
				"95999F",
				"ACAEB2",
				"CAC2BE",
			]
		},
		{
			index = 12,
			path = "res://assets/fineart/00013_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"1B1B1B",
				"241481",
				"2F1F6E",
				"A6A6A5",
				"D0D0D0",
				"D21713",
				"F5F5F5",
				"F9CE23",
			]
		},
		{
			index = 13,
			path = "res://assets/fineart/00014_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"322F2E",
				"574F33",
				"5F5F5D",
				"707C82",
				"768CB3",
				"9C6B38",
				"A0A5A4",
				"B4A24C",
			]
		},
		{
			index = 14,
			path = "res://assets/fineart/00015_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"281C14",
				"505739",
				"592B23",
				"60825A",
				"A35D36",
				"BB9A49",
				"C8BBAC",
				"D59C1E",
			]
		},
		{
			index = 15,
			path = "res://assets/fineart/00016_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"4D473A",
				"6B2A20",
				"7F816D",
				"895A3F",
				"A0916C",
				"C6B286",
				"D4B072",
				"DFC17C",
			]
		},
		{
			index = 16,
			path = "res://assets/fineart/00017_240x360.png",
			width = 240,
			height = 360,
			palette = [
				"122020",
				"255866",
				"2E6B8C",
				"3E5F5D",
				"58A4AB",
				"639C97",
				"819A73",
				"ADCBAB",
			]
		}
	]
}

var _finearts = data.fineart
var _finearts_full = []

func _ready():
	randomize()
	_finearts_full = _finearts.duplicate()
	_finearts.shuffle()


func get_fineart():
	if _finearts.is_empty():
		_finearts = _finearts_full.duplicate()
		_finearts.shuffle()

	var random_fineart = _finearts.pop_front()
	return random_fineart

var user_arts = []
var _max_arts = 20

func _add_user_art(_fa_img: Image, _u_img: Image):
	user_arts.push_front({"u_img": _u_img, "fa_img": _fa_img})
	if(user_arts.size() > _max_arts):
		user_arts.pop_back()
