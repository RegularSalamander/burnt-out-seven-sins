extends KinematicBody2D

var bullet_scn

var velocity = Vector2(0, 0)

var animation_frame = 0
var time_since_shot = 10

var dead_enemy_scn

# does the instruction, then waits the time (in seconds)
var instructions = []
var instruction_time_left = 0
var instruction_idx = 0

var health = 1

var rng = RandomNumberGenerator.new()

func load_enemy(enemy_idx):
	var handle : File = File.new()
	var _o = handle.open("res://Scripts/enemies.json", File.READ)
	var fileText = handle.get_as_text()
	handle.close()
	var enemies = parse_json(fileText)
	var stats = enemies["enemies"][enemy_idx]
	instructions = stats["instructions"]
	health = stats["health"]
	# position should go from -64 to 64
	rng.randomize()
	position.x = rng.randf_range(stats["min_x_position"], stats["max_x_position"])

func _ready():
	bullet_scn = load("res://Scenes/EnemyBullet.tscn")
	dead_enemy_scn = load("res://Scenes/Dead Enemy.tscn")

func _physics_process(delta):
	animation_frame += delta * 5
	time_since_shot += delta
	var frame = int(floor(animation_frame))%2
	if time_since_shot < 0.3:
		frame += 2
	$Sprite.frame = frame
	
	if health <= 0:
		var new_dead_enemy = dead_enemy_scn.instance()
		new_dead_enemy.position = position
		get_parent().add_child(new_dead_enemy)
		if rng.randf() < 0.5: #50% chance of an item
			get_parent().spawn_item(position, true)
		queue_free()
	if position.y - get_parent().get_node("Player").position.y > 150:
		queue_free()
	instruction_time_left -= delta
	
	# while so it can do multiple instructions in one frame
	while instruction_time_left <= 0:
		do_instruction(instructions[instruction_idx])
		instruction_time_left = instructions[instruction_idx + 1]
		instruction_idx += 2
		instruction_idx %= instructions.size()
	
	move_and_slide(velocity)

func do_instruction(instruction):
	if instruction.begins_with("shoot"):
		time_since_shot = 0

	if instruction == "stop":
		velocity = Vector2(0, 0)
	elif instruction == "right":
		velocity = Vector2(30, 0)
	elif instruction == "left":
		velocity = Vector2(-30, 0)
	elif instruction == "random":
		var theta = rng.randf_range(0, 2*PI)
		velocity = Vector2(cos(theta)*30, sin(theta)*30)
	elif instruction == "shoot":
		var new_bullet = bullet_scn.instance()
		new_bullet.position = position
		new_bullet.velocity = Vector2(0, 50)
		get_parent().add_child(new_bullet)
	elif instruction == "shoot three":
		var new_bullet_1 = bullet_scn.instance()
		new_bullet_1.position = position
		new_bullet_1.velocity = Vector2(0, 50)
		get_parent().add_child(new_bullet_1)
		var new_bullet_2 = bullet_scn.instance()
		new_bullet_2.position = position
		new_bullet_2.velocity = Vector2(40, 50)
		get_parent().add_child(new_bullet_2)
		var new_bullet_3 = bullet_scn.instance()
		new_bullet_3.position = position
		new_bullet_3.velocity = Vector2(-40, 50)
		get_parent().add_child(new_bullet_3)
	elif instruction == "shoot circle":
		for i in range(8):
			
			var theta = (float(i)/8) * 2*PI
			var new_bullet = bullet_scn.instance()
			new_bullet.position = position
			new_bullet.velocity = Vector2(cos(theta)*50, sin(theta)*50)
			get_parent().add_child(new_bullet)
	elif instruction == "shoot circle offset":
		for i in range(8):
			#offset by a 16th
			var theta = (float(i)/8) * 2*PI + PI/8
			var new_bullet = bullet_scn.instance()
			new_bullet.position = position
			new_bullet.velocity = Vector2(cos(theta)*50, sin(theta)*50)
			get_parent().add_child(new_bullet)
	elif instruction == "shoot target":
		var new_bullet = bullet_scn.instance()
		new_bullet.position = position
		var player_pos = get_parent().get_node("Player").position
		var theta = atan2(player_pos.y - position.y, player_pos.x - position.x)
		new_bullet.velocity = Vector2(cos(theta)*50, sin(theta)*50)
		get_parent().add_child(new_bullet)
	pass


func _on_Hurtbox_area_entered(area):
	#delete the bullet that hit
	area.get_parent().queue_free()
	# this area only collides with things that hurt the enemy
	# so checking the object doesn't matter
	# this will only be called when the enemy collides player bullets
	health -= 1
	get_parent().sins[3] += 0.3 #wrath sin
