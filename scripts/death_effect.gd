extends Area2D

@onready var timer: Timer = $Timer
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("KillZone triggered by Player")

		var global_sound = get_node("/root/game3/GlobalDeathSound")
		if global_sound:
			print("Playing death sound")
			global_sound.play()
		else:
			print("ERROR: GlobalDeathSound not found!")
