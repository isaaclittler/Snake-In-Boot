extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_level_reset():# Remove the current level
	print("0")
	var level = get_node("level")
	remove_child(level)
	level.call_deferred("free")
	print("1")
	# Add the next level
	level = preload("res://Scenes/level1.tscn").instance()
	print("2")
	add_child(level)
	level.connect("reset", self, "_on_level_reset")