extends KinematicBody2D
const cameraHeight = 284
const cameraWidth = 495
const placementOffset = 5

const GRAVITY = 250.0
const BASE_SPEED = 350
const JUMP_SPEED = 350

const NUM_TRAPS = 3

const REFRESH_TIME = 2
const NUM_SPIKES = 3
const SPIKE_TIME = 1
const NUM_WALLS = 3
const WALL_TIME = .5
const NUM_SAWS = 1
const SAW_TIME = 1.5

export var left = ""
export var right = ""
export var a = ""
export var b = ""
export var x = ""
export var y = ""

var buildTime = 0
var tBuild = 0
var inBuild = false
var spikes = NUM_SPIKES
var saws = NUM_SAWS
var walls = NUM_WALLS
var cameraX = 0
var tFreeze = 0
var dFreeze = 1
var velocity = Vector2()
var frozen = false
var direction = 0
var trapNum = 0
var curTrap

func _ready():
	pass

func _process(delta):
	if frozen == true:
		tFreeze += delta
		if tFreeze > dFreeze:
			frozen = false
			tFreeze = 0
	if inBuild == true:
		tBuild += delta
		if tBuild >= buildTime:
			buildTrap()
			tBuild = 0
	displayTrap()
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
	if Input.is_action_pressed(left):
		move(-1)
		direction = -1
	elif Input.is_action_pressed(right):
		move(1)
		direction = 1
	else:
		move(0)
	if Input.is_action_pressed(a)\
	and is_on_floor():
		print("jump")
		jump()
	if Input.is_action_just_pressed(x)\
	and inBuild == false:
		toggleTrap()
	if Input.is_action_just_pressed(b)\
	and inBuild == false:
		building()

func toggleTrap():
	print("toggle item")
	if curTrap != null:
		curTrap.queue_free()
		curTrap = null
	trapNum += 1
	if trapNum > NUM_TRAPS:
		trapNum = 0
	if trapNum == 1:
		curTrap = load("res://Scenes/abilities/preSpike.tscn").instance()
		add_child(curTrap)
	if trapNum == 2:
		curTrap = load("res://Scenes/abilities/preWallTrap.tscn").instance()
		add_child(curTrap)
	if trapNum == 3:
		curTrap = load("res://Scenes/abilities/preSpinTrap.tscn").instance()
		add_child(curTrap)

func building():
	if trapNum == 0:
		buildTime = REFRESH_TIME
		inBuild = true
	if trapNum == 1\
	and spikes != 0:
		spikes -= 1
		buildTime = SPIKE_TIME
		inBuild = true
	if trapNum == 2\
	and walls != 0:
		walls -= 1
		buildTime = WALL_TIME
		inBuild = true
	if trapNum == 3\
	and saws != 0:
		saws -= 1
		buildTime = SAW_TIME
		inBuild = true

func buildTrap():
	print("building ",trapNum)
	if trapNum == 0:
		spikes = NUM_SPIKES
		walls = NUM_WALLS
		saws = NUM_SAWS
	if trapNum == 1:
		var trap = load("res://Scenes/levelObjects/spikes.tscn").instance()
		get_parent().add_child(trap)
		trap.position = Vector2(self.position.x + direction * 32,self.position.y)
	if trapNum == 2:
		var trap = load("res://Scenes/abilities/wallTrap.tscn").instance()
		get_parent().add_child(trap)
		trap.position = Vector2(self.position.x + direction * 32,self.position.y)
	if trapNum == 3:
		var trap = load("res://Scenes/abilities/spinTrap.tscn").instance()
		get_parent().add_child(trap)
		trap.position = Vector2(self.position.x + direction * 32,self.position.y)
	inBuild = false
		
	buildTime = 0

func displayTrap():
	if direction != 0\
	and curTrap != null:
		curTrap.position.x = direction * 32

func _physics_process(delta):
	if is_on_floor():
		velocity.y = 0
	if inBuild == false:
		getInput()
	if frozen == false\
	and inBuild == false:
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