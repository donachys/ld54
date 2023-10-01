extends Label


func _ready():
    var global_vars := get_node("/root/GlobalVariables")
    var score_format_string = "Total Earnings: $%*.*f"
    text = score_format_string % [5, 2, global_vars.total_score]
