extends Node2D

var fade
var flame

var fade_in = 1
var animation_frame = 5
var backwards = true

func _ready():
	fade = $Sprite2
	flame = $Sprite

func _process(delta):
	if backwards:
		animation_frame -= delta * 5
		if animation_frame <= 0:
			animation_frame = 0
			backwards = false
	else:
		animation_frame += delta * 5
		animation_frame = min(19, animation_frame)
	fade_in -= delta
	
	fade.modulate.a = fade_in
	flame.frame = floor(animation_frame)
