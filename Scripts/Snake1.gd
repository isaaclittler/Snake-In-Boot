extends KinematicBody2D

export var leftInput = ""
export var rightInput = ""
export var aInput = ""
export var bInput = ""
export var numAirJumps = 1
export var ability = 0
export var spriteY = 0


const GRAVITY = 250.0
const BASE_SPEED = 200
const JUMP_SPEED = 200

onready var bird = get_node("../Bird1")

var velocity = Vector2()
var curAirJumps = 1
var abilityTemp = ability

func _process(delta):
	if ability != abilityTemp:
		updateSprite()
		abilityTemp = ability

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
	if Input.is_action_just_pressed(aInput) and is_on_floor():
		velocity.y = -JUMP_SPEED
	elif Input.is_action_just_pressed(aInput) and curAirJumps != 0:
		velocity.y = -JUMP_SPEED
		curAirJumps -= 1
	elif Input.is_action_just_pressed(aInput)\
	and ability == 1\
	and curAirJumps == 0:
		velocity.y = -JUMP_SPEED
		ability = 0
		print("extra jump")
	if Input.is_action_just_pressed(bInput):
		useAbility()
	move_and_slide(velocity, Vector2(0, -1))

func useAbility():
	if ability == 0:
		print("nothing")
	if ability == 2:
		print("ability 2")
		bird.frozen = true
		ability = 0

func updateSprite():
	var sprite = get_child(0)
	var region = Rect2(ability * 32,spriteY,32,32)
	sprite.set_region_rect(region)

func _on_EnemyCollisionCheck_area_entered(area):
	print("collision")
	queue_free()
