extends KinematicBody2D

#set by the object instancing it
var velocity = Vector2(0, 0)

func _physics_process(delta):
	#collision is handled by the player and enemies, not bullets
	move_and_collide(velocity*delta)
