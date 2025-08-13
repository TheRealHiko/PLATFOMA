extends Node

var score = 0
var coin_count = 0

@onready var score_label: Label = $"../Labels/ScoreLabel"
@onready var coins_label: Label = $"../Player/Camera2D/CanvasLayer/Panel2/COINS"

func add_point():
	score += 1
	score_label.text = "YOU COLLECTED " + str(score) + "/100 COINS"
	
	coin_count += 1
	coins_label.text = "(" + str(coin_count) + ")"
