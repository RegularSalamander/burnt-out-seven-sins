extends Node2D

var world_gen
var player
var sin_labels

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

func _process(delta):
	#TODO implement the up or down mechanic of every sin
	sins[0] += 0.005 #sloth up fast
	sins[6] += 0.001 #pride up slow
	
	sins[1] -= 0.001 #greed down slow
	sins[2] -= 0.001 #gluttony down slow
	sins[3] -= 0.001 #wrath down slow
	sins[4] -= 0.001 #envy down slow
	sins[5] -= 0.001 #lust down slow
	
		
	for i in range(7):
		sins[i] = max(min(sins[i], 1), 0) #constrain between 0 and 1
		sin_labels[i].modulate.a = sins[i]
	
	world_gen.set_height(player.position.y)
