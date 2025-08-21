extends Node2D
class_name PlayerState

# Adjust these paths based on your scene tree
@onready var player = get_parent().get_parent().get_node_or_null("Player")
var animation_player: AnimationPlayer = null


func _ready() -> void:
	set_physics_process(false)
	print("Loaded state: ", name)
	print("Player ref: ", player)
	print("AnimationPlayer ref: ", animation_player)

func enter(anim_name: String = "") -> void:
	set_physics_process(true)
	if animation_player and anim_name != "":
		animation_player.play(anim_name)

func exit() -> void:
	set_physics_process(false)

func transition() -> void:
	pass

func _physics_process(delta: float) -> void:
	transition()
