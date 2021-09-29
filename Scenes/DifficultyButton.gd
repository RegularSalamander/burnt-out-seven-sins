extends Button

export (int) var difficulty = 1

func _pressed():
	get_node("/root/Global").difficulty = difficulty
	get_tree().change_scene("res://Scenes/Game.tscn")
