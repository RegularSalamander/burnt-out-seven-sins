extends Node2D

var world_gen
var player

var sins = [
	0, #wrath
	0, #gluttony
	0, #sloth
	0, #greed
	0, #pride
	0,
	0
]

#variables needed to keep track of sins
var time_since_moved = 0
var time_since_player_damaged = 0

func _ready():
	world_gen = $WorldGen
	player = $Player

func _process(delta):
	time_since_moved += delta
	time_since_player_damaged += delta
	
	if time_since_moved > 5: #5 seconds of not moving
		sins[3] += 1 #sloth sin
		time_since_moved -= 5
	if time_since_player_damaged > 10: #20 seconds of not being damaged
		sins[1] += 1 #pride sin
		time_since_player_damaged -= 10
	
	#returns true if the max height generated moved up
	if world_gen.set_height(player.position.y):
		time_since_moved = 0
