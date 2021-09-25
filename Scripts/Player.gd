extends KinematicBody2D

# speed in pixels per second
export (int) var moveSpeed = 150

var bullet_scn

# the directional buttons the player is pressing
var input = [0, 0, 0, 0]
var shooting = false
# keeps track of the direction the player is facing
# (isn't useful yet, but we'll need it when the player has actual animations)
var lastDir = 0
var reload_time = 0

var i_frames = 0
var health = 3

func _ready():
	bullet_scn = load("res://Scenes/PlayerBullet.tscn")

func _physics_process(delta):
	reload_time -= delta
	i_frames -= delta
	
	var velocity = Vector2(int(input[3])-int(input[2]), int(input[1])-int(input[0]))
	if velocity.x > 0:
		lastDir = 3
	elif velocity.x < 0:
		lastDir = 1
	elif velocity.y < 0:
		lastDir = 2
	elif velocity.y > 0:
		lastDir = 0
	
	if shooting and reload_time <= 0:
		var new_bullet = bullet_scn.instance()
		new_bullet.position = position
		new_bullet.velocity = Vector2(0, -300)
		new_bullet.time_to_live = 2
		get_parent().add_child(new_bullet)
		# half second reload
		reload_time = 0.5
	
	velocity *= moveSpeed
	if shooting:
		velocity *= 0.5
	# move and slide uses delta internally for some reason
	move_and_slide(velocity)

func _input(event):
	# event.is_action works for wasd or arrows
	if event.is_action_pressed("ui_up") and not input[0]:
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
	
	if event.is_action_pressed("jump"):
		shooting = true
	if event.is_action_released("jump"):
		shooting = false
	pass


func _on_Hurtbox_area_entered(area):
	#delete the bullet that hit
	area.get_parent().queue_free()
	# this area only collides with things that hurt the player
	# so checking the object doesn't matter
	# this will only be called when the player collides with enemies or enemy bullets
	if i_frames <= 0:
		health -= 1
		i_frames = 0.5 #half a second of invincibility
		get_parent().time_since_player_damaged = 0 #for sloth sin
