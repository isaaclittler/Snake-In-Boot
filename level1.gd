extends Node


var snakes = 0
var cameraControl
var finishX = 700
signal reset

func _ready(): #set the finish point by object in here
	connect("reset", self, "root")
	print("level loaded")
	pass

func winCond():
	snakes = 0
	for snake in get_tree().get_nodes_in_group("snakes"):
		snakes+=1
	if snakes== 0:
		print("bird win")
		emit_signal("reset")
	cameraControl = get_child(0)
	if (cameraControl.furthestX >= finishX):
		print(cameraControl.winningSnake," snake wins")
		emit_signal("reset")

func reLoad():
	# Remove the current level
	var root = get_owner()
	var level = root.get_node("level")
	root.remove_child(level)
	level.call_deferred("free")

	# Add the next level
	var next_level_resource = load("res://level1.tscn")
	var next_level = next_level.instance()
	root.add_child(next_level)

func _process(delta):
	winCond()
