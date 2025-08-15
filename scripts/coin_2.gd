extends Area2D

@onready var game_manager_2: Node = %GameManager2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	print("+1 Coin")
	animation_player.play("pickup animation")
	game_manager_2.add_point()
