extends KinematicBody2D

var bullet_scn

var velocity = Vector2(0, 0)

# does the instruction, then waits the time (in seconds)
var instructions = [
	"right", 0.5,
		"shoot", 0.5,
		"shoot", 0.5,
		"shoot", 0.5,
		"shoot", 0.5,
	"left", 0.5,
		"shoot", 0.5,
		"shoot", 0.5,
		"shoot", 0.5,
		"shoot", 0.5
]
var instruction_time_left = 0
var instruction_idx = 0

func _ready():
	bullet_scn = load("res://Scenes/EnemyBullet.tscn")

func _process(delta):
	instruction_time_left -= delta
	
	# while so it can do multiple instructions in one frame
	while instruction_time_left <= 0:
		do_instruction(instructions[instruction_idx])
		instruction_time_left = instructions[instruction_idx + 1]
		instruction_idx += 2
		instruction_idx %= instructions.size()
	
	move_and_collide(velocity * delta)

func do_instruction(instruction):
	if instruction == "right":
		velocity = Vector2(100, 0)
	elif instruction == "left":
		velocity = Vector2(-100, 0)
	elif instruction == "shoot":
		var new_bullet_1 = bullet_scn.instance()
		new_bullet_1.position = position
		new_bullet_1.velocity = Vector2(0, 150)
		get_parent().add_child(new_bullet_1)
		var new_bullet_2 = bullet_scn.instance()
		new_bullet_2.position = position
		new_bullet_2.velocity = Vector2(100, 150)
		get_parent().add_child(new_bullet_2)
		var new_bullet_3 = bullet_scn.instance()
		new_bullet_3.position = position
		new_bullet_3.velocity = Vector2(-100, 150)
		get_parent().add_child(new_bullet_3)
	pass
