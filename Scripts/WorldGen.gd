extends Node2D

# furthest height generated
var lastGenerated = 500

var stair_scn

func _ready():
	# we can make multiple of these scenes and switch between them randomly
	stair_scn = load("res://Scenes/stairs.tscn")

# set the y the player is at
func set_height(player_height):
	#generate 300 pixels ahead of the player
	while player_height - 300 < lastGenerated:
		# placeholder stairs are 144 pixels tall
		lastGenerated -= 144
		generate(lastGenerated)

func generate(height):
	var new_stairs = stair_scn.instance()
	new_stairs.position.y = height
	add_child(new_stairs)
	#todo: spawn enemies, obstacles
