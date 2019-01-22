extends KinematicBody2D

const rotationSpeed = 2
const speed = 350
const cameraHeight = 284
const cameraWidth = 495

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
onready var laser = get_node("../laser")
onready var prelaser = get_node("../prelaser")

#func _ready():
	
	#pass

var velocity = Vector2()
var rotationDir = 0
signal visionBlock

func _process(delta):
	tAbility3 += delta
	dAbility3 += delta
	if lasering == true:
		laser()
	if frozen == true:
		tFreeze += delta
		if tFreeze > dFreeze:
			frozen = false
			tFreeze = 0
	abilityReset()

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
	and lasering == false:
		#print("pew pew")
		emit_signal("visionBlock")
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
		laser.position.y = -5000

func ability3():
	if tAbility3 > 5:
		print("ability 3")
		currRotationSpeed = .5
		currSpeed = 100
		tAbility3 = 0
		dAbility3 = 0
		lasering = true

func laser():
	if tAbility3 < 1:
		prelaser.position = self.position
		prelaser.rotation = self.rotation + PI * .5
	else:
		laser.position = self.position
		laser.rotation = self.rotation + PI * .5
		prelaser.position.y = 5000

func _on_TopArea_area_entered(area):
	self.position = Vector2(self.position.x, cameraHeight)
	print("top")


func _on_BotArea_area_entered(area):
	self.position = Vector2(self.position.x, -cameraHeight)
	print("bot")


func _on_RightArea_area_entered(area):
	cameraX = get_node("../cameraControl").position.x
	self.position = Vector2(cameraX-(cameraWidth),self.position.y)
	print("right")



func _on_LeftArea_area_entered(area):
	cameraX = get_node("../cameraControl").position.x
	self.position = Vector2(cameraX+(cameraWidth),self.position.y)
	print("left")
