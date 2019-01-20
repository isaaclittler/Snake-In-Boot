extends KinematicBody2D

const rotationSpeed = 3
const speed = 350
const cameraHeight = 284
const cameraWidth = 495

var cameraX = 0

func _ready():
	
	pass

var velocity = Vector2()
var rotationDir = 0
signal visionBlock

func getInput():
	rotationDir = 0
	velocity = Vector2()
	if Input.is_action_pressed("bird_move_left"):
		rotationDir -= 1
	elif Input.is_action_pressed("bird_move_right"):
		rotationDir += 1
	if Input.is_action_just_pressed("bird_ability_1"):
		print("pew pew")
		emit_signal("visionBlock")

func _physics_process(delta):
	getInput()
	rotation += rotationDir * rotationSpeed * delta
	velocity = Vector2(speed,0).rotated(rotation)
	move_and_slide(velocity)


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
