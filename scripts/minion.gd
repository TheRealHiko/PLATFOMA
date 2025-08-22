extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
var player: Node2D = null
@export var speed: float = 60.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_error("Player not found for minion!")

	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("idle")

func _physics_process(delta: float) -> void:
	if not player:
		return
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func take_damage() -> void:
	queue_free()
