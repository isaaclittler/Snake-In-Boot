extends KinematicBody2D

const rotationSpeed = 2
const speed = 350
const cameraHeight = 284
const cameraWidth = 495
const placementOffset = 5

export var left = ""
export var right = ""
export var a = ""
export var b = ""
export var x = ""
export var y = ""

var cameraX = 0
var currRotationSpeed = rotationSpeed
var currSpeed = speed
var tAbility3 = 5
var dAbility3 = 0
var tFreeze = 0
var dFreeze = 1
var lasering = false
export var frozen = false
var laser
var prelaser
var laserPart2
var tSmoke = 2.5

func _ready():
	pass

var velocity = Vector2()
var rotationDir = 0
signal visionBlock

func _process(delta):
	tSmoke += delta
	tAbility3 += delta
	dAbility3 += delta
	if lasering == true:
		laser()
	if frozen == true:
		tFreeze += delta
		if tFreeze > dFreeze:
			frozen = false
			tFreeze = 0
	birdTeleport()
	abilityReset()

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
	rotationDir = 0
	velocity = Vector2()
	if Input.is_action_pressed(left):
		rotationDir -= 1
	elif Input.is_action_pressed(right):
		rotationDir += 1
	#if Input.is_action_just_pressed("bird_ability_1")\
	#and lasering == false:
	#	rotation += PI
	if Input.is_action_just_pressed(a)\
	and lasering == false\
	and tSmoke >= 2.5:
		#print("pew pew")
		var smoke = preload("res://Scenes/abilities/smokeScreen.tscn").instance()
		get_parent().add_child(smoke)
		tSmoke = 0
	if Input.is_action_just_pressed(b):
		ability3()
	#if Input.is_action_just_pressed("bird_ability_4"):
		

func _physics_process(delta):
	getInput()
	if frozen == false:
		rotation += rotationDir * currRotationSpeed * delta
		velocity = Vector2(currSpeed,0).rotated(rotation)
		move_and_slide(velocity)

func abilityReset():
	if dAbility3 > 3:
		currRotationSpeed = rotationSpeed
		currSpeed = speed
		lasering = false
		#laser.position.y = -5000

func ability3():
	if tAbility3 > 5:
		print("ability 3")
		if lasering == false:
			prelaser = preload("res://Scenes/abilities/prelaser.tscn").instance()
			add_child(prelaser)
		laserPart2 = false
		currRotationSpeed = .5
		currSpeed = 100
		tAbility3 = 0
		dAbility3 = 0
		lasering = true

func laser():
	if tAbility3 >= 1\
	and laserPart2 == false:
		prelaser.queue_free()
		laser = preload("res://Scenes/abilities/laser.tscn").instance()
		add_child(laser)
		laserPart2 = true
	if tAbility3 >=  3:
		laser.queue_free()
		lasering == false

