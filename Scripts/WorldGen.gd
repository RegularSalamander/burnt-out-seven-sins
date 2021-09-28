extends Node2D

# furthest height generated
var last_height_generated = 0
var last_enemy_height = 0

var stair_scn
var platform_scn
var enemy_scn

var screen_border
var enemy_data

var level = 2 #starts at 0, goes to 7
var player_level = 2 #the level the player is actually in
var progress = 0 #progress through the level
var difficulty = 1
#0 is saint (easy),
#1 is normal,
#2 is sinner (hard),
#3 is hell (super hard)

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	# we can make multiple of these scenes and switch between them randomly
	stair_scn = load("res://Scenes/stairs.tscn")
	platform_scn = load("res://Scenes/Platform.tscn")
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
	if progress == 0:
		var new_platform = platform_scn.instance()
		new_platform.position.y = height
		new_platform.get_node("DialogTrigger").level = level
		add_child(new_platform)
		pass
	if progress > 0 and progress < 30:
		var new_stairs = stair_scn.instance()
		new_stairs.position.y = height
		add_child(new_stairs)
		if rng.randf() < 0.3: #30% chance of a spawned item
			get_parent().spawn_item(Vector2(rng.randf_range(-50, 50), rng.randf_range(-30, 30)+height), false)
	if progress > 3  and progress < 30 and progress%3 == 0:
		#budget of enemy spawning is determined by level and difficulty
		#set to level+difficulty+1
		#minimum is 1
		#maximum is 6+difficulty
		var budget = min(max(level+difficulty+1, 1), 6+difficulty)
		var enemies_spawned = 0
		while budget >= 1 and enemies_spawned < 3:
			var enemy_idx = rng.randi_range(0, enemy_data["enemies"].size()-1)
			if enemy_data["enemies"][enemy_idx]["difficulty"] <= budget:
				enemies_spawned += 1
				var new_enemy = enemy_scn.instance() #todo: make random and determined by difficulty
				new_enemy.load_enemy(enemy_idx)
				new_enemy.position.y = height + rng.randf_range(-20.0, 20.0)
				get_parent().add_child(new_enemy)
				last_enemy_height = height
				budget -= enemy_data["enemies"][enemy_idx]["difficulty"]
	progress += 1
	if progress == 30:
		level += 1
		progress = 0
		pass
