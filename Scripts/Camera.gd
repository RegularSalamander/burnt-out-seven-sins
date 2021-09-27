extends Node2D

var player

func _ready():
	player = get_parent().get_node("Player")

func _process(_delta):
	if player.position.y < position.y:
		position = Vector2(0, floor(player.position.y))
		get_parent().sins[0] -= 0.01 #sloth down faster
	pass
