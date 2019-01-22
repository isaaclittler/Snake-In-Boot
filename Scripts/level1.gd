extends Node


var snakes = 0
var cameraControl
export var finishX = 3000
export var winner = "snake wins"
export var birdNumber = 0
signal reset

func _ready(): #set the finish point by object in here
	connect("reset", self, "root")
	if get_parent().lvlSelect == 1:
		var loading = preload("res://Scenes/levels/lvl_1.tscn").instance()
		add_child(loading)
		print("1")
	elif get_parent().lvlSelect == 2:
		var loading = preload("res://Scenes/levels/lvl_2.tscn").instance()
		add_child(loading)
		print("2")
	elif get_parent().lvlSelect == 3:
		var loading = preload("res://Scenes/levels/lvl_3.tscn").instance()
		add_child(loading)
		print("2")
	setControllers()
	print("level loaded")
	pass

func setControllers():
	var i = birdNumber + 1
	var bird = get_child(1)
	bird.left = str("p",birdNumber,"L")
	bird.right = str("p",birdNumber,"R") 
	bird.a = str("p",birdNumber,"A")
	bird.b = str("p",birdNumber,"B")  
	bird.x = str("p",birdNumber,"X") 
	bird.y = str("p",birdNumber,"Y") 
	for snake in get_tree().get_nodes_in_group("snakes"):
		snake.leftInput = str("p",i,"L")
		snake.rightInput =  str("p",i,"R")
		snake.aInput =  str("p",i,"A")
		i += 1
		if i > 3:
			i = 0

func winCond():
	snakes = 0
	for snake in get_tree().get_nodes_in_group("snakes"):
		snakes+=1
	if snakes == 0:
		winner = "bird win"
		emit_signal("reset")
	cameraControl = get_child(0)
	if (cameraControl.furthestX >= finishX):
		print(cameraControl.winningSnake," snake wins")
		emit_signal("reset")

func _process(delta):
	winCond()
