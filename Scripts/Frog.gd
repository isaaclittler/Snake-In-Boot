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

var inside = false
var moving = false
var movement = 0
var curPosition
var tounge
var toungeOut = false
var tTounge = 0
var cameraX = 0
var tFreeze = 0
var dFreeze = 1
var velocity = Vector2()
var frozen = false
var canTeleport = true

func _ready():
	print(self)
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
	curPosition = self.position


func _physics_process(delta):
	getInput()
	if(inside == true):
		moveFrogOut()
		print(inside)
	if frozen == false:
		if velocity.y < GRAVITY * 1.5:
			velocity.y += delta * GRAVITY
		if (is_on_ceiling()):
			velocity.y += JUMP_SPEED / 2
		platformerTeleport()
		move_and_slide(velocity, Vector2(0, -1))

#checks if area in direction is free to teleport to
#returns false if closed, true if not
func checkTeleportArea(i):
#	var area = load("res://Scenes/abilities/frogTeleport.tscn").instance()
	canTeleport = true
##	get_parent().add_child(area)
##	if i == 0: #up
##		area.position = Vector2(self.position.x, cameraHeight)
##	if i == 1: #down
##		area.position = Vector2(self.position.x, -cameraHeight)
##	if i == 2: #right
##		area.position = Vector2(cameraX-(cameraWidth)+placementOffset,self.position.y)
##	if i == 3: #left
##		area.position = Vector2(cameraX+(cameraWidth)-placementOffset,self.position.y)
##	connect("body_entered",area,"_on_Area2D_area_entered")
##	area.queue_free()
	var query = Physics2DShapeQueryParameters.new()
	var areaPosition
	if i == 0: #up
		areaPosition = Vector2(self.position.x, cameraHeight)
	if i == 1: #down
		areaPosition = Vector2(self.position.x, -cameraHeight)
	if i == 2: #right
		areaPosition = Vector2(cameraX-(cameraWidth)-placementOffset,self.position.y)
	if i == 3: #left
		areaPosition = Vector2(cameraX+(cameraWidth)+placementOffset,self.position.y)
	var transformation = Transform2D()
	query.set_transform(transformation)
	query.set_shape(get_child(1).shape)
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.collide_shape(query)
	print(result)
	if result:
		canTeleport = false
		#print("cant teleport")
	return canTeleport

func platformerTeleport():
	if self.position.y < -cameraHeight\
	and checkTeleportArea(0) == true: #top
		self.position = Vector2(self.position.x, cameraHeight)
		#print("top")
	if self.position.y > cameraHeight\
	and checkTeleportArea(1) == true:#bot
		self.position = Vector2(self.position.x, -cameraHeight)
		#print("bot")
	if get_node("../cameraControl").position.x < (self.position.x - cameraWidth)\
	and checkTeleportArea(2) == true:#right
		cameraX = get_node("../cameraControl").position.x
		self.position = Vector2(cameraX-(cameraWidth)+placementOffset,self.position.y)
		#print("right")
	if get_node("../cameraControl").position.x > (self.position.x + cameraWidth)\
	and checkTeleportArea(3) == true: #left
		cameraX = get_node("../cameraControl").position.x
		self.position = Vector2(cameraX+(cameraWidth)-placementOffset,self.position.y)
		#print("left")

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
	if is_on_floor():
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

func moveFrogOut():
	var destination = get_parent().get_child(0).position
	var curPos = self.position
#	if curPos.x > destination.x:
#		movement.x = -16
#	elif curPos.x < destination.x:
#		movement.x = 16
	if moving == false:
		if curPos.y > 0:
			movement = -16
			moving = true
		elif curPos.y < 0:
			movement = 16
			moving = true
	if (inside == true):
		self.position = Vector2(self.position.x,self.position.y + movement)

func _on_frogDetection_body_entered(body):
	print("body entered")
	inside = true


func _on_frogDetection_body_exited(body):
	print("body exited")
	inside = false
	moving = false
