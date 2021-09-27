extends KinematicBody2D

# speed in pixels per second
export (int) var moveSpeed = 55

var bullet_scn

var sprite
var sins

# the directional buttons the player is pressing
var input = [0, 0, 0, 0]
var shooting = false
# keeps track of the direction the player is facing
# (isn't useful yet, but we'll need it when the player has actual animations)
var lastDir = 0
var reload_time = 0
var sin_theta = 0

var i_frames = 0
var health = 3
var can_move = true

var rng = RandomNumberGenerator.new()

func _ready():
	bullet_scn = load("res://Scenes/PlayerBullet.tscn")
	
	sprite = $Sprite
	sins = [
		$Gluttony,
		$Sloth,
		$Envy,
		$Wrath,
		$Greed,
		$Lust,
		$Pride
	]

func _physics_process(delta):
	sin_theta += delta
	reload_time -= delta
	i_frames -= delta
	
	if health <= 0:
		can_move = false
	
	for i in range(len(sins)):
		# lower all but red when alpha is greater than 0.8
		sins[i].modulate.g = min(max(0, sins[i].modulate.a*-5 + 5), 1)
		sins[i].modulate.b = min(max(0, sins[i].modulate.a*-5 + 5), 1)
		if sins[i].modulate.a >= 1:
			sins[i].modulate.g = 1
		var shake_x = rng.randf_range(-2.0, 2.0)
		var shake_y = rng.randf_range(-2.0, 2.0)
		sins[i].rect_position.x = cos(sin_theta + (i*2*PI/7.0))*25-15 + shake_x * sins[i].modulate.a
		sins[i].rect_position.y = sin(sin_theta + (i*2*PI/7.0))*25-15 + shake_y * sins[i].modulate.a
	
	#i_frame flicker
	if i_frames > 0 and int(floor(i_frames*20))%2==0:
		sprite.modulate.a = 0
	else:
		sprite.modulate.a = 1
	if not can_move:
		return
	
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
		new_bullet.velocity = Vector2(0, -110)
		new_bullet.time_to_live = 1
		get_parent().add_child(new_bullet)
		# half second reload
		reload_time = 0.5
		get_parent().sins[1] += 0.2 #greed up
	
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
	#delete the bullet or pickup that hit
	if area.get_parent().name.begins_with("Heart") or area.get_parent().name.begins_with("@Heart"):
		health = min(3, health+1) #limit to three hearts
		get_parent().sins[5] += 0.6 #lust sin up
		if area.get_parent().is_from_enemy:
			get_parent().sins[4] += 0.6 #envy sin up
	elif area.get_parent().name.begins_with("Powerup") or area.get_parent().name.begins_with("@Powerup"):
		if area.get_parent().is_from_enemy:
			get_parent().sins[4] += 0.6 #envy sin up
		pass
	elif area.get_parent().name.begins_with("Bullet") or area.get_parent().name.begins_with("@Bullet"):
		# so checking the object doesn't matter
		# this will only be called when the player collides with enemies or enemy bullets
		if i_frames <= 0:
			health -= 1
			i_frames = 0.5 #half a second of invincibility
			get_parent().sins[6] -= 1 #pride sin down
	area.get_parent().queue_free()
	print(area.get_parent().name)
