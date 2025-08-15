@tool
extends Control

@export var world_index: int = 1
@onready var player_icon = $PlayerIcon

# Each world has an icon node and a linked scene file
@onready var levels = [
	{
		"node": $WorldIconEasy,
		"scene": "res://scenes/game2.tscn"
	},
	{
		"node": $WorldIconNormal,
		"scene": "res://scenes/game3.tscn"
	},
	{
		"node": $WorldIconInsane,
		"scene": "res://scenes/game.tscn"
	},
	{
		"node": $WorldIconMedium,
		"scene": "res://scenes/game4.tscn"
	},
	{
		"node": $WorldIconImpossible,
		"scene": "res://scenes/game5.tscn"
	},
	{
		"node": $WorldIconHard,
		"scene": "res://scenes/game6.tscn"
	}
]

var current_level: int = 0

func _ready():
	# Move player icon to first world
	_update_player_position()

func _input(event):
	# Move left
	if event.is_action_pressed("vi_left") and current_level > 0:
		current_level -= 1
		_update_player_position()

	# Move right
	if event.is_action_pressed("vi_right") and current_level < levels.size() - 1:
		current_level += 1
		_update_player_position()

	# Confirm selection
	if event.is_action_pressed("vi_accept"):
		var scene_path = levels[current_level]["scene"]
		get_tree().change_scene_to_file(scene_path)

func _update_player_position():
	if player_icon and levels[current_level]["node"]:
		player_icon.global_position = levels[current_level]["node"].global_position
	else:
		push_warning("PlayerIcon or level node not found!")
