extends Node

# class member variables go here, for example:
# var a = 2
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
	remove_child(level)
	level.call_deferred("free")
	#gameEndScreen
	gameEnd = preload("res://Scenes/gameEndScreen.tscn").instance()
	add_child(gameEnd)
	gameEnd = get_node("MarginContainer/Label")
	gameEnd.text = gameWinner
	# Add the next level
	level = preload("res://Scenes/level1.tscn").instance()
	add_child(level)
	level.connect("reset", self, "_on_level_reset")