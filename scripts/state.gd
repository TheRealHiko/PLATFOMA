extends Node2D
class_name PlayerState

@onready var debug = owner.find_child("debug")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animation_player = owner.find_child("AnimationPlayer")

func _ready():
	set_physics_process(false)

func enter(anim_name: String = "skill") -> void:
	set_physics_process(true)
	if animation_player and anim_name != "":
		animation_player.play(anim_name)

func exit() -> void:
	set_physics_process(false)

func transition() -> void:
	pass

func _physics_process(_delta: float) -> void:
	transition()
	if debug:
		debug.text = name
