extends Node


var snakes = 0
var cameraControl
export var finishX = 1500
export var winner = "snake wins"
signal reset

func _ready(): #set the finish point by object in here
	connect("reset", self, "root")
	print("level loaded")
	pass

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
