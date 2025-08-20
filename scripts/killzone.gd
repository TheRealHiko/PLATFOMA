extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("KillZone triggered by Player")

		GlobalDeathSound.play()
		body.get_node("CollisionShape2D").queue_free()
		Engine.time_scale = 0.18

		timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1

	# Find Player again
	var player := get_tree().current_scene.get_node_or_null("Player")
	if player:
		var panel := player.get_node_or_null("Camera2D/CanvasLayer/Panel")
		if panel:
			panel.save_time()
			print("✅ Time saved:", panel.time)
		else:
			print("❌ Panel not found under Player")
	else:
		print("❌ Player not found in scene")

	get_tree().reload_current_scene()
