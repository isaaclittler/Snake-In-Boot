extends Sprite

# class member variables go here, for example:
# var a = 2

var cooldown = 2.5
var duration = 2
var durationTime = 0
var cooldownTime = cooldown
var canSmoke = true

func _ready():
	pass

func _process(delta):
	durationTime += delta
	cooldownTime += delta
	resetSmoke()
 

func resetSmoke():
	if durationTime > duration:
		self.visible = false
		durationTime = 0
	if cooldownTime > cooldown:
		canSmoke = true

func _on_Bird1_visionBlock():
	if canSmoke == true:
		var location = get_node("../Bird1").position
		self.position = location
		self.visible = true
		canSmoke = false
		durationTime = 0
		cooldownTime = 0



