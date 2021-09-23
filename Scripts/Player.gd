extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var yvel = 0
var grounded = true

var leftvel = 0
var rightvel = 0

var movevel = 800
var jumpvel = 1000
var grav = 2000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += (leftvel + rightvel) * delta
	if position.y > 0:
		position.y = 0
		grounded = true
	elif !grounded:
		yvel += grav * delta
		position.y += yvel * delta
	pass

# TODO: check if there's a better way to do this
func _input(event):
	if event.is_action_pressed("jump") && grounded:
		yvel = -jumpvel
		grounded = false
	if event.is_action_pressed("left"):
		leftvel = -movevel
	if event.is_action_released("left"):
		leftvel = 0
	if event.is_action_pressed("right"):
		rightvel = jumpvel
	if event.is_action_released("right"):
		rightvel = 0
	pass
