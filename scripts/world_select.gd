extends Control

# Which world index to start on
@export var world_index: int = 0

# Store world icons and scene paths together
@onready var levels = [
	{ "node": $WorldIconEasy, "scene": "res://scenes/game2.tscn" },
	{ "node": $WorldIconNormal, "scene": "res://scenes/game_3.tscn" },
	{ "node": $WorldIconInsane, "scene": "res://scenes/game.tscn" },
	{ "node": $WorldIconMedium, "scene": "res://scenes/game4.tscn" },
	{ "node": $WorldIconImpossible, "scene": "res://scenes/game5.tscn" },
	{ "node": $WorldIconHard, "scene": "res://scenes/game6.tscn" }
]

var current_level: int = 0

func _ready():
	# Place player icon at the first world's position
	_update_player_position()

func _input(event):
	if event.is_action_pressed("vi_left") and current_level > 0:
		current_level -= 1
		_update_player_position()

	if event.is_action_pressed("vi_right") and current_level < levels.size() - 1:
		current_level += 1
		_update_player_position()

	if event.is_action_pressed("vi_accept"):
		get_tree().change_scene_to_file(levels[current_level]["scene"])

func _update_player_position():
	$PlayerIcon.global_position = levels[current_level]["node"].global_position
