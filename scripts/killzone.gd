extends Area2D

@onready var timer: Timer = $Timer
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("KillZone triggered by Player")

		var global_sound = get_node("/root/Game/GlobalDeathSound")
		if global_sound:
			print("Playing death sound")
			global_sound.play()
		else:
			print("ERROR: GlobalDeathSound not found!")

		body.get_node("CollisionShape2D").queue_free()
		Engine.time_scale = 0.3
	
		timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
