extends Node

# class member variables go here, for example:
# var a = 2
export var lvlSelect = 1
var gameEnd
var gameWinner

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_level_reset():# Remove the current level
	var level = get_node("level")
	gameWinner = level.winner
	level_delete()
	gameEnd = preload("res://Scenes/gameEndScreen.tscn").instance()
	add_child(gameEnd)
	gameEnd = get_node("MarginContainer/Label")
	gameEnd.text = gameWinner
	level_delete()

func level_delete():
	var level = get_node("level")
	remove_child(level)

func level_load():
	var level = preload("res://Scenes/level1.tscn").instance()
	add_child(level)
	level.connect("reset", self, "_on_level_reset")

func _on_Button_pressed():
	lvlSelect = 1
	level_delete()
	level_load()


func _on_Button2_pressed():
	lvlSelect = 2
	level_delete()
	level_load()


func _on_Button3_pressed():
	lvlSelect = 3
	level_delete()
	level_load()
