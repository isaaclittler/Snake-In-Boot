extends KinematicBody2D

export var leftInput = "ui_left"
export var rightInput = "ui_right"
export var upInput = "ui_up"
export var numAirJumps = 1

const GRAVITY = 250.0
const BASE_SPEED = 200
const JUMP_SPEED = 200

var velocity = Vector2()
var curAirJumps = 1

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	if Input.is_action_pressed(leftInput):
		velocity.x = -BASE_SPEED
	elif Input.is_action_pressed(rightInput):
		velocity.x =  BASE_SPEED
	else:
		velocity.x = 0
	if (is_on_ceiling()):
		velocity.y += JUMP_SPEED / 2
	if is_on_floor():
		curAirJumps = numAirJumps
	if Input.is_action_just_pressed(upInput) and is_on_floor():
		velocity.y = -JUMP_SPEED
	elif Input.is_action_just_pressed(upInput) and curAirJumps != 0:
		velocity.y = -JUMP_SPEED
		curAirJumps -= 1
	
	move_and_slide(velocity, Vector2(0, -1))

func _on_EnemyCollisionCheck_area_entered(area):
	print("collision")
	queue_free()
