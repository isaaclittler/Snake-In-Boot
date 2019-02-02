extends Node

export var finishX = 3000
export var winner = "snake wins"
export var birdNumber = 0
export var winningPlayer = 4
export var finishedLoading = 0

signal reset

var scene = ""
var numPlayers = 4
var snakes = 0
var cameraControl
var bossNumber = 0

func _ready(): #set the finish point by object in here
	finishedLoading = 0
	connect("reset", self, "root")
	var i = get_parent().lvlSelect
	scene = str("res://Scenes/levels/lvl_",i,".tscn")
	var loading = load(scene).instance()
	add_child(loading)
	load_boss()
	load_snakes()
	setControllers()
	print(birdNumber,",level loaded")
	finishedLoading = 1

func load_boss():
	var loading
	if bossNumber == 0: #load bird
		loading = load("res://Scenes/characters/Bird1.tscn").instance()
		add_child(loading)

func load_snakes():
	var i = 0
	var loading
	for i in (numPlayers - 1):
		loading = load("res://Scenes/characters/Snake1.tscn").instance()
		add_child(loading)
		loading.position.x += i * 32
		loading.spriteY += i * 32
		print(loading.spriteY)

func setControllers():
	var snakeAbi = get_parent().snakeAbilities
	if get_parent().firstLoad == true:
		randomize()
		birdNumber = randi()%4
	else:
		birdNumber = get_parent().playerWinner
	print("bird,",birdNumber)
	var i = birdNumber + 1
	var bird = get_child(2)
	bird.left = str("p",birdNumber,"L")
	bird.right = str("p",birdNumber,"R") 
	bird.a = str("p",birdNumber,"A")
	bird.b = str("p",birdNumber,"B")  
	bird.x = str("p",birdNumber,"X") 
	bird.y = str("p",birdNumber,"Y") 
	for snake in get_tree().get_nodes_in_group("snakes"):
		if snakeAbi > 0:
			if snakeAbi > 3:
				snakeAbi = 3
			var ability = randi()%4 + 1
			if ability == 4:
				ability = 5
			snake.ability = ability
			snakeAbi += -1
		snake.leftInput = str("p",i,"L")
		snake.rightInput =  str("p",i,"R")
		snake.aInput =  str("p",i,"A")
		snake.bInput =  str("p",i,"B")
		i += 1
		if i > 3: #trying 4, was 3
			i = 0

func winCond():
	snakes = 0
	for snake in get_tree().get_nodes_in_group("snakes"):
		snakes+=1
	if snakes == 0:
		winner = "bird win"
		emit_signal("reset")
	cameraControl = get_child(0)
	if (cameraControl.furthestX >= finishX):
		print(cameraControl.winningSnake," snake wins")
		winningPlayer = cameraControl.winningSnake.to_int()
		#print(winningPlayer * 2)
		emit_signal("reset")

func _process(delta):
	if finishedLoading == 1:
		winCond()
