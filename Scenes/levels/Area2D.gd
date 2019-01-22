extends Area2D

# class member variables go here, for example:
export var abilityType = 1
signal pickedUp

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):



func snakeFind():
	for snake in get_tree().get_nodes_in_group("snakes"):
		if overlaps_body(snake) == true:
			snake.ability = abilityType
			emit_signal("pickedUp")



func _on_Area2D_body_entered(body):
	snakeFind()
	print("entered")
