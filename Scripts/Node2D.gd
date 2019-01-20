extends Node2D

# class member variables go here, for example:
# var a = 2
export var furthestX = 0
export var winningSnake = "test"
var snake
var furthestSnake = null
var temp = 0

func furthestSnake():
	furthestSnake = get_tree().get_nodes_in_group("snakes")[0]
	furthestX = furthestSnake.position.x
	for snake in get_tree().get_nodes_in_group("snakes"):
		temp = snake.position.x
		if temp > furthestX:
			furthestSnake = snake
		#elif snake.position.x 
	if (furthestSnake != null):
		furthestX = furthestSnake.position.x
		winningSnake = furthestSnake

func _process(delta):
	furthestSnake()
	self.position = (Vector2(furthestX,0))
	pass
