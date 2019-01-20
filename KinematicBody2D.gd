extends KinematicBody2D

const rotationSpeed = 2
const speed = 300

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

var velocity = Vector2()
var rotationDir = 0

func getInput():
	rotationDir = 0
	velocity = Vector2()
	if Input.is_action_pressed("bird_move_left"):
		rotationDir -= 1
	elif Input.is_action_pressed("bird_move_right"):
		rotationDir += 1

func _physics_process(delta):
	getInput()
	rotation += rotationDir * rotationSpeed * delta
	velocity = Vector2(speed,0).rotated(rotation)
	move_and_slide(velocity)
