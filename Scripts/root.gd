extends Node

const numLevels = 3
const numBosses = 2

export var p0Boss = 0
export var p1Boss = 0
export var p2Boss = 0
export var p3Boss = 0
export var lvlSelect = 1
export var playerWinner = 0
export var firstLoad = true
export var snakeAbilities = 0

var curLevel = 0
var gameEnd
var gameWinner
var printing = ""
var birdGamesWon = 0

func _ready():
	firstLoad = false

func _process(delta):
	bossSelect()

func bossSelect():
	if Input.is_action_just_pressed("p0Y"):
		p0Boss += 1
		if p0Boss >= numBosses:
			p0Boss = 0
		var region = Rect2(p0Boss * 32,0,32,32)
		get_node("level/cameraControl/player0Boss").set_region_rect(region)
	if Input.is_action_just_pressed("p1Y"):
		p1Boss += 1
		if p1Boss >= numBosses:
			p1Boss = 0
		var region = Rect2(p1Boss * 32,0,32,32)
		get_node("level/cameraControl/player1Boss").set_region_rect(region)
	if Input.is_action_just_pressed("p2Y"):
		p2Boss += 1
		if p2Boss >= numBosses:
			p2Boss = 0
		var region = Rect2(p2Boss * 32,0,32,32)
		get_node("level/cameraControl/player2Boss").set_region_rect(region)
	if Input.is_action_just_pressed("p3Y"):
		p3Boss += 1
		if p3Boss >= numBosses:
			p3Boss = 0
		var region = Rect2(p3Boss * 32,0,32,32)
		get_node("level/cameraControl/player3Boss").set_region_rect(region)

func _on_level_reset():# Remove the current level
	game_win()
	level_delete()
	level_load()
	update_text()

func update_text():
	gameEnd = get_node("MarginContainer/Label")
	if gameEnd != null:
		gameEnd.text = printing

func game_win():
	var birdScreen = "bird win x %d"
	var level = get_node("level")
	gameWinner = level.winner
	if gameWinner == "bird win":
		playerWinner = level.birdNumber
		birdGamesWon += 1
		if birdGamesWon < 3:
			printing = ""
		else:
			if snakeAbilities > 0:
				printing = birdScreen % snakeAbilities
			else:
				printing = "bird win"
			birdGamesWon = 0
			snakeAbilities += 1
			lvlSelect = (randi()%numLevels + 1)
	else:
		birdGamesWon = 0
		snakeAbilities = 0
		playerWinner = level.winningPlayer
		printing = "snake win"
	print(playerWinner,"root")


func level_delete():
	var level = get_node("level")
	remove_child(level)

func level_load():
	var level = preload("res://Scenes/level1.tscn").instance()
	add_child(level)
	#level.birdNumber = playerWinner
	level.connect("reset", self, "_on_level_reset")
	gameEnd = preload("res://Scenes/gameEndScreen.tscn").instance()
	add_child(gameEnd)

func level_select(a):
	snakeAbilities = 0
	lvlSelect = a
	birdGamesWon = 0
	printing = ""
	randomize()
	playerWinner = randi()%4
	level_delete()
	update_text()
	level_load()


func _on_Button_pressed():
	level_select(1)

func _on_Button2_pressed():
	level_select(2)

func _on_Button3_pressed():
	level_select(3)

func _on_Button4_pressed():
	level_select(4)


func _on_Button5_pressed():
	level_select(5)
