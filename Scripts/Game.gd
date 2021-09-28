extends Node2D

var world_gen
var player
var sin_labels

var rng = RandomNumberGenerator.new()

var heart_scn
var powerup_scn

var fade = 1

var sins = [
	0, #0: sloth
	0, #1: greed
	0, #2: gluttony
	0, #3: wrath
	0, #4: envy
	0, #5: lust
	0 #6: pride
]

func _ready():
	rng.randomize()
	
	world_gen = $WorldGen
	player = $Player
	sin_labels = [
		$Player/Sloth,
		$Player/Greed,
		$Player/Gluttony,
		$Player/Wrath,
		$Player/Envy,
		$Player/Lust,
		$Player/Pride
	]
	heart_scn = load("res://Scenes/Heart.tscn")
	powerup_scn = load("res://Scenes/Powerup.tscn")
	
	load_checkpoint(Global.checkpoint)

func _process(delta):
	$CanvasLayer/Health.frame = player.health
	
	if player.health > 0:
		fade -= 0.01
		fade = max(fade, 0)
	else:
		fade += 0.01
		if fade >= 1:
			get_tree().change_scene("res://Scenes/Game.tscn")
	$CanvasLayer/Fadeout.modulate.a = fade
	
	$CanvasLayer/progress.visible = world_gen.player_level >= 0
	$CanvasLayer/progress/flame.position.y = player.position.y/(72*30*8) * 128 + 181
	
	var update_sins = true
	for i in range(7):
		if sins[i] >= 1:
			update_sins = false
	if update_sins:
		sins[0] += 0.003 #sloth up fast
		sins[6] += 0.001 #pride up slow
		
		sins[1] -= 0.001 #greed down slow
		sins[2] -= 0.001 #gluttony down slow
		sins[3] -= 0.001 #wrath down slow
		sins[4] -= 0.001 #envy down slow
		sins[5] -= 0.001 #lust down slow
	for i in range(7):
		if Global.just_loaded or update_sins and (not player.can_move or (i + 2 > world_gen.player_level and Global.difficulty != 3)):
			sins[i] = 0
		sins[i] = max(min(sins[i], 1), 0) #constrain between 0 and 1
		sin_labels[i].modulate.a = sins[i]
	
	world_gen.set_height(player.position.y)

func spawn_item(pos, is_from_enemy):
	if rng.randf() < 0.2: #20% chance of a powerup
		var new_powerup = powerup_scn.instance()
		new_powerup.position = pos
		new_powerup.is_from_enemy = is_from_enemy
		add_child(new_powerup)
	else:
		var new_heart = heart_scn.instance()
		new_heart.position = pos
		new_heart.is_from_enemy = is_from_enemy
		add_child(new_heart)
	pass

func load_checkpoint(level):
	Global.just_loaded = true
	world_gen.level = (level-1)
	world_gen.player_level = (level-1)
	if level == 1:
		world_gen.level = 1
		world_gen.player_level = 1
		return
	world_gen.progress = 28
	world_gen.last_height_generated = -72*30*(level-1)+72*2
	player.position.y = -72*30*(level-1)-30
