extends "res://scripts/player.gd"

@export var bullet_node: PackedScene

func shoot() -> void:
	if bullet_node == null:
		push_error("Bullet scene not assigned in the Inspector!")
		return

	var bullet = bullet_node.instantiate()
	bullet.global_position = global_position

	# set direction towards mouse
	bullet.direction = (get_global_mouse_position() - global_position).normalized()

	get_tree().current_scene.add_child(bullet)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()
