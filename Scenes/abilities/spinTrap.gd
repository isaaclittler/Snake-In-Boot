extends Sprite

const ROTATION_SPEED = 2


func _process(delta):
	self.rotation += delta * ROTATION_SPEED
