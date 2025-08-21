extends "res://scripts/player.gd"

 
@export var bullet_node: PackedScene

func shoot():
	var bullet = bullet_node.instantiate()
 
	bullet.position = global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child",bullet)
 
func _input(event):
	if event.is_action("shoot"):
		shoot()
