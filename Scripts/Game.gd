extends Node2D

var world_gen
var player

var health = 0

func _ready():
	world_gen = $WorldGen
	player = $Player
	health = player.health

func _process(delta):
	world_gen.set_height(player.position.y)
