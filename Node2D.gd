extends Node2D

# class member variables go here, for example:
# var a = 2
var furthestX = 0
var snake
var snakePosition

func furthestSnake():
	for snake in get_tree().get_nodes_in_group("snakes"):
		snakePosition = snake.position.x
	furthestX = snakePosition
func _process(delta):
	furthestSnake()
	self.position = (Vector2(furthestX,0))
	pass
