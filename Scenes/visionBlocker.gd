extends Sprite

# class member variables go here, for example:
# var a = 2

var duration = 2
var durationTime = 0

func _ready():
	var location = get_node("../Bird1").position
	self.position = location

func _process(delta):
	durationTime += delta
	resetSmoke()
 

func resetSmoke():
	if durationTime >= duration:
		self.queue_free()




