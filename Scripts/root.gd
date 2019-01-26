extends Node

# class member variables go here, for example:
# var a = 2
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

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


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
			lvlSelect = (randi()%4 + 1)
	else:
		birdGamesWon = 0
		snakeAbilities = 0
		playerWinner = level.winningPlayer
		printing = "snake win"
	#print(playerWinner,"root")


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
