extends Area2D

var level = 0

func _ready():
	pass # Replace with function body.


func _on_DialogTrigger_area_entered(area):
	# world_gen level
	get_parent().get_parent().player_level += 1
	#TODO trigger dialog
	
	#delete self after
	queue_free()
	pass # Replace with function body.
