extends Button

export (int) var difficulty = 1

func _ready():
	if difficulty == 0:
		grab_focus()

func _pressed():
	if difficulty == -1:
		get_tree().quit()
	Global.difficulty = difficulty
	Global.checkpoint = 1
	get_tree().change_scene("res://Scenes/Game.tscn")
