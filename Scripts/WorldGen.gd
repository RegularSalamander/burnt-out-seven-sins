extends Node2D

# furthest height generated
var lastGenerated = 500

var stair_scene

func _ready():
	# we can make multiple of these scenes and switch between them randomly
	stair_scene = load("res://Scenes/stairs.tscn")

# set the y the player is at
func set_height(player_height):
	print(player_height)
	#generate 200 pixels ahead of the player
	while player_height - 200 < lastGenerated:
		# placeholder stairs are 144 pixels tall
		lastGenerated -= 144
		generate(lastGenerated)

func generate(height):
	var new_stairs = stair_scene.instance()
	new_stairs.position.y = height
	add_child(new_stairs)
	#todo: spawn enemies, obstacles
