extends KinematicBody2D

const cameraHeight = 284
const cameraWidth = 495
const placementOffset = 5

const GRAVITY = 150.0
const BASE_SPEED = 200
const JUMP_SPEED = 300
const TOUNGE_DURATION = 1

export var left = ""
export var right = ""
export var a = ""
export var b = ""
export var x = ""
export var y = ""

var tounge
var toungeOut = false
var tTounge = 0
var cameraX = 0
var tFreeze = 0
var dFreeze = 1
var velocity = Vector2()
var frozen = false

func _ready():
	pass

func _process(delta):
	if frozen == true:
		tFreeze += delta
		if tFreeze > dFreeze:
			frozen = false
			tFreeze = 0
	if toungeOut == true:
		tTounge += delta
		if tTounge > TOUNGE_DURATION:
			tTounge = 0
			toungeOut = false
			tounge.queue_free()
	abilityReset()
	birdTeleport()

func birdTeleport():
	if self.position.y < -cameraHeight: #top
		self.position = Vector2(self.position.x, cameraHeight)
		print("top")
	if self.position.y > cameraHeight:#bot
		self.position = Vector2(self.position.x, -cameraHeight)
		print("bot")
	if get_node("../cameraControl").position.x < (self.position.x - cameraWidth):#right
		cameraX = get_node("../cameraControl").position.x
		self.position = Vector2(cameraX-(cameraWidth)+placementOffset,self.position.y)
		print("right")
	if get_node("../cameraControl").position.x > (self.position.x + cameraWidth): #left
		cameraX = get_node("../cameraControl").position.x
		self.position = Vector2(cameraX+(cameraWidth)-placementOffset,self.position.y)
		print("left")

func getInput():
	if Input.is_action_pressed(left)\
	and is_on_floor() == false:
		move(-1)
	elif Input.is_action_pressed(right)\
	and is_on_floor() == false:
		move(1)
	else:
		move(0)
	if Input.is_action_pressed(left)\
	and Input.is_action_just_pressed(b):
		tounge(-1)
	elif Input.is_action_pressed(right)\
	and Input.is_action_just_pressed(b):
		tounge(1)
	elif Input.is_action_just_pressed(b)\
	and is_on_floor() == true:
		tounge(0)
	if Input.is_action_pressed(a)\
	and is_on_floor():
		jump()

func tounge(direction):
	if toungeOut == false:
		if direction == 1:
			print("rightT")
			tounge = load("res://Scenes/abilities/tounge.tscn").instance()
			add_child(tounge)
			tounge.position.x += 48
			toungeOut = true
		if direction == -1:
			tounge = load("res://Scenes/abilities/tounge.tscn").instance()
			add_child(tounge)
			tounge.position.x -= 48
			print("leftT")
			toungeOut = true
		if direction == 0:
			print("upT")

func _physics_process(delta):
	getInput()
	if frozen == false:
		if velocity.y < GRAVITY * 1.5:
			velocity.y += delta * GRAVITY
		if (is_on_ceiling()):
			velocity.y += JUMP_SPEED / 2
		move_and_slide(velocity, Vector2(0, -1))


func jump():
	velocity.y = -JUMP_SPEED

func move(direction):
	var speed = BASE_SPEED
	if direction == 1:
		velocity.x = speed
	elif direction == -1: #left
		velocity.x = -speed
	else:
		velocity.x = 0

func abilityReset():
	pass

