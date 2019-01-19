extends KinematicBody2D

const GRAVITY = 200.0
const BASE_SPEED = 200
const JUMP_SPEED = 200

var velocity = Vector2()

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	if Input.is_action_pressed("ui_left"):
		velocity.x = -BASE_SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  BASE_SPEED
	else:
		velocity.x = 0
		
	if (is_on_ceiling()):
		velocity.y += JUMP_SPEED / 2
		
	if Input.is_action_just_pressed("ui_up") && is_on_floor():
		velocity.y = -JUMP_SPEED
	
	move_and_slide(velocity, Vector2(0, -1))