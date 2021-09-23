extends KinematicBody2D

# speed in pixels per second
export (int) var moveSpeed = 100

# the directional buttons the player is pressing
var input = [0, 0, 0, 0]
# keeps track of the direction the player is facing
# (isn't useful yet, but we'll need it when the player has actual animations)
var lastDir = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var motion = Vector2(int(input[3])-int(input[2]), int(input[1])-int(input[0]))
	if motion.x > 0:
		lastDir = 3
	elif motion.x < 0:
		lastDir = 1
	elif motion.y < 0:
		lastDir = 2
	elif motion.y > 0:
		lastDir = 0
	motion *= moveSpeed
	# move and slide uses delta internally for some fuckin reason
	var _slidevel = move_and_slide(motion)

func _input(event):
	# event.is_action works for wasd or arrows
	if event.is_action("ui_up") and not input[0]:
		input[0] = true
	if event.is_action_released("ui_up"):
		input[0] = false
	if event.is_action_pressed("ui_down"):
		input[1] = true
	if event.is_action_released("ui_down"):
		input[1] = false
	if event.is_action_pressed("ui_left"):
		input[2] = true
	if event.is_action_released("ui_left"):
		input[2] = false
	if event.is_action_pressed("ui_right"):
		input[3] = true
	if event.is_action_released("ui_right"):
		input[3] = false
	pass
