extends KinematicBody2D

var bullet_scn

var velocity = Vector2(0, 0)

# does the instruction, then waits the time (in seconds)
var instructions = [
	"right", 0.3,
		"shoot", 0.3,
		"shoot", 0.3,
		"shoot", 0.3,
		"shoot", 0.3,
	"stop", 0.1,
		"shoot circle", 0.5,
		"shoot circle offset", 0.5,
		"shoot circle", 0.5,
	"left", 0.3,
		"shoot", 0.3,
		"shoot", 0.3,
		"shoot", 0.3,
		"shoot", 0.3,
	"stop", 0.1,
		"shoot circle", 0.5,
		"shoot circle offset", 0.5,
		"shoot circle", 0.5,
]
var instruction_time_left = 0
var instruction_idx = 0

var health = 1

func _ready():
	bullet_scn = load("res://Scenes/EnemyBullet.tscn")

func _process(delta):
	if health <= 0:
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
	if instruction == "stop":
		velocity = Vector2(0, 0)
	elif instruction == "right":
		velocity = Vector2(30, 0)
	elif instruction == "left":
		velocity = Vector2(-30, 0)
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
	pass


func _on_Hurtbox_area_entered(area):
	#delete the bullet that hit
	area.get_parent().queue_free()
	# this area only collides with things that hurt the enemy
	# so checking the object doesn't matter
	# this will only be called when the enemy collides player bullets
	health -= 1
	get_parent().sins[0] += 1 #wrath sin
