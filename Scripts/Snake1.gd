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
var flip = false


func _process(delta):
	if ability != abilityTemp:
		updateSprite()
		abilityTemp = ability
	updateSprite()

func _physics_process(delta):
	gravity(delta)
	if Input.is_action_pressed(leftInput):
		move(-1)
	elif Input.is_action_pressed(rightInput):
		move(1)
	else:
		move(0)
	floorCeiling()
	if Input.is_action_just_pressed(aInput):
		if is_on_floor()\
		and flip == false:
			jump()
			print("ground jump")
		if is_on_ceiling()\
		and flip == true:
			jump()
			print("ground jump")
	if Input.is_action_just_pressed(aInput) and curAirJumps != 0:
		if is_on_floor() == false\
		and flip == false:
			jump()
			curAirJumps -= 1
			print("air jump")
		if is_on_ceiling() == false\
		and flip == true:
			jump()
			curAirJumps -= 1
			print("air jump")
	elif Input.is_action_just_pressed(aInput)\
	and ability == 1\
	and curAirJumps == 0:
		jump()
		ability = 0
		print("extra jump")
	if Input.is_action_just_pressed(bInput):
		useAbility()
	if flip == false:
		move_and_slide(velocity, Vector2(0, -1))
	else:
		move_and_slide(velocity, Vector2(1, 0))

func floorCeiling():
	if (is_on_ceiling()):
		if flip == false:
			velocity.y += JUMP_SPEED / 2
		else:
			curAirJumps = numAirJumps
	if is_on_floor():
		if flip == false:
			curAirJumps = numAirJumps
		else:
			velocity.x += JUMP_SPEED / 2

func gravity(delta):
	if flip == false:
		if ability == 7\
		and is_on_floor() != true\
		and velocity.y < GRAVITY * .5:
			velocity.y += delta * GRAVITY * .5
		elif is_on_floor() != true\
		and velocity.y < GRAVITY:
			velocity.y += delta * GRAVITY
	else:
		if ability == 7\
		and is_on_floor() != true\
		and velocity.x < GRAVITY * .5:
			velocity.x += delta * GRAVITY * .5
		elif is_on_ceiling() != true\
		and velocity.x < GRAVITY:
			velocity.x += delta * GRAVITY

func jump():
	if flip == false:
		velocity.y = -JUMP_SPEED
	else:
		velocity.x = -JUMP_SPEED

func move(direction):
	var speed = BASE_SPEED
	if ability == 5:
		if is_on_floor() == true\
		and flip == false:
			speed += 100
		if is_on_ceiling() == true\
		and flip == true:
			speed += 100
	if direction == 1: #right
		if flip == false:
			velocity.x = speed
		else:
			velocity.y = -speed
	elif direction == -1: #left
		if flip == false:
			velocity.x = -speed
		else:
			velocity.y = speed
	else:
		if flip == false:
			velocity.x = 0
		else:
			velocity.y = 0

func flipGravity():
	var temp = velocity.x
	velocity.x = velocity.y
	velocity.y = temp
	print(velocity)
	move_and_slide(velocity, Vector2(1,0))

func useAbility():
	if ability == 0:
		print("nothing")
	if ability == 2:
		print("ability 2")
		bird.frozen = true
		ability = 0
	if ability == 3:
		var platform = load("res://Scenes/abilities/redCarpet.tscn").instance()
		platform.position = Vector2(self.position.x + 32,self.position.y + 30)
		get_parent().add_child(platform)
		ability = 0
	if ability == 4:
		self.rotation = -(.5 * PI)
		flip = true
		velocity.x = 0
		velocity.y = 0

func updateSprite():
	var sprite = get_child(0)
	var region = Rect2(ability * 32,spriteY,32,32)
	sprite.set_region_rect(region)

func _on_EnemyCollisionCheck_area_entered(area):
	print("collision")
	queue_free()
