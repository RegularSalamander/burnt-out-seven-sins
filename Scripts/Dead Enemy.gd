extends Sprite

var animation_frame = 0

func _process(delta):
	animation_frame += delta * 5
	frame = int(floor(animation_frame))
	if animation_frame >= 4:
		queue_free()
	
