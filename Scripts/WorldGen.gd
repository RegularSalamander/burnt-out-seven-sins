extends Node2D

# furthest height generated
var last_height_generated = 0
var last_enemy_height = 0

var stair_scn
var enemy_scn
var difficulty = 0

var screen_border
var enemy_data

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	# we can make multiple of these scenes and switch between them randomly
	stair_scn = load("res://Scenes/stairs.tscn")
	enemy_scn = load("res://Scenes/Enemy.tscn")
	screen_border = $"Screen Border"
	
	var handle : File = File.new()
	var _o = handle.open("enemies.json", File.READ)
	var fileText = handle.get_as_text()
	handle.close()
	enemy_data = parse_json(fileText)

# set the y the player is at
func set_height(player_height):
	#screen border half the height under player
	if player_height < screen_border.position.y - 225/2:
		screen_border.position = Vector2(0, player_height + 225/2)
	
	#generate 100 pixels ahead of the player
	while player_height - 100 < last_height_generated:
		# placeholder stairs are 72 pixels tall
		last_height_generated -= 72
		generate(last_height_generated)

func generate(height):
	var new_stairs = stair_scn.instance()
	new_stairs.position.y = height
	add_child(new_stairs)
	# 200 pixels since last enemy spawn
	if height - last_enemy_height < -200:
		var budget = 5 #should be based on difficulty
		while budget > 0:
			var enemy_idx = rng.randi_range(0, enemy_data["enemies"].size()-1)
			if enemy_data["enemies"][enemy_idx]["difficulty"] <= budget:
				var new_enemy = enemy_scn.instance() #todo: make random and determined by difficulty
				new_enemy.load_enemy(enemy_idx)
				new_enemy.position.y = height
				get_parent().add_child(new_enemy)
				last_enemy_height = height
				budget -= enemy_data["enemies"][enemy_idx]["difficulty"]
		
	
	#todo: obstacles
