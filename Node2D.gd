extends Node2D

# class member variables go here, for example:
# var a = 2
export var furthestX = 0
export var winningSnake = "test"
var snake
var furthestSnake = null

func furthestSnake():
	for snake in get_tree().get_nodes_in_group("snakes"):
		if (furthestX < snake.position.x):
			furthestSnake = snake
	if (furthestSnake != null):
		furthestX = furthestSnake.position.x
		winningSnake = furthestSnake

func _process(delta):
	furthestSnake()
	self.position = (Vector2(furthestX,0))
	pass
