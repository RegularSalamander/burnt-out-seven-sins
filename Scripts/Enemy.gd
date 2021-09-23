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
		velocity = Vector2(20, 0)
	elif instruction == "left":
		velocity = Vector2(-20, 0)
	elif instruction == "shoot":
		var new_bullet = bullet_scn.instance()
		new_bullet.position = position
		new_bullet.velocity = Vector2(0, 100)
		get_parent().add_child(new_bullet)
	pass
