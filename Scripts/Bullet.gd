extends KinematicBody2D

#set by the object instancing it
var velocity = Vector2(0, 0)
var time_to_live = 5 # delete se;f after five seconds

func _physics_process(delta):
	time_to_live -= delta
	if time_to_live <= 0:
		#if player's bullet, add to the greed sin
		if name.begins_with("Player"):
			get_parent().sins[4] += 1
		queue_free()
	#collision is handled by the player and enemies, not bullets
	move_and_collide(velocity*delta)
