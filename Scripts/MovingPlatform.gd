extends Sprite

export var xMovement = 0.0
export var yMovement = 0.0
export var duration = 1.0
var time = 0


func _process(delta):
	if time < duration:
		self.position = Vector2(self.position.x+xMovement,self.position.y+yMovement)
	elif time > ( duration * 2):
		time = 0
	else:
		self.position = Vector2(self.position.x-xMovement,self.position.y-yMovement)
	time += delta
