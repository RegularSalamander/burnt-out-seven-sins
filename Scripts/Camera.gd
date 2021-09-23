extends Node2D

var player

func _ready():
	player = get_parent().get_node("Player")

func _process(_delta):
	position = Vector2(0,player.position.y)
	pass
