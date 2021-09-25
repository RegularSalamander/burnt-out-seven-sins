extends Node2D

# furthest height generated
var last_height_generated = 0
var last_enemy_height = 0

var stair_scn
var enemy_scns = []
var difficulty = 0

var screen_border

func _ready():
	# we can make multiple of these scenes and switch between them randomly
	stair_scn = load("res://Scenes/stairs.tscn")
	enemy_scns.append(load("res://Scenes/Enemy.tscn"))
	screen_border = $"Screen Border"

# set the y the player is at
func set_height(player_height):
	#screen border half the height under player
	if player_height < screen_border.position.y - 224/2:
		screen_border.position = Vector2(0, player_height + 224/2)
	
	var did_move = false
	#generate 300 pixels ahead of the player
	while player_height - 300 < last_height_generated:
		did_move = true
		# placeholder stairs are 72 pixels tall
		last_height_generated -= 72
		generate(last_height_generated)
	return did_move

func generate(height):
	var new_stairs = stair_scn.instance()
	new_stairs.position.y = height
	add_child(new_stairs)
	# 200 pixels since last enemy spawn
	# should be controlled by difficulty instead of hard coded later
	if height - last_enemy_height < -200:
		var new_enemy = enemy_scns[0].instance() #todo: make random and determined by difficulty
		new_enemy.position = Vector2(-50, height)
		get_parent().add_child(new_enemy)
		last_enemy_height = height
	
	#todo: obstacles
