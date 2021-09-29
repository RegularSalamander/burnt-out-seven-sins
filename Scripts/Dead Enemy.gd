extends Sprite

var animation_frame = 0
var type = 0

var type = 0

func _process(delta):
	animation_frame += delta * 5
	frame = type*8+4+int(floor(animation_frame))
	if animation_frame >= 4:
		queue_free()
	
