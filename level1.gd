extends Node


var snakes = 0
var cameraControl
var finishX = 700

func _ready(): #set the finish point by object in here
	pass

func winCond():
	snakes = 0
	for snake in get_tree().get_nodes_in_group("snakes"):
		snakes+=1
	if snakes== 0:
		print("bird win")
	cameraControl = get_child(0)
	if (cameraControl.furthestX >= finishX):
		print(cameraControl.winningSnake," snake wins")

func _process(delta):
	winCond()
