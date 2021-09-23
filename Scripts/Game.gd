extends Node2D

var world_gen
var player

func _ready():
	world_gen = $WorldGen
	player = $Player

func _process(delta):
	world_gen.set_height(player.position.y)
