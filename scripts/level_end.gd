extends Area2D

@onready var timer_panel = $"../Player/Camera2D/CanvasLayer/Panel"

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):  # make sure Player is in group "Player"
		timer_panel.stop()
		print("Timer stopped! Level complete.")
		$"../Player/Camera2D/CanvasLayer/Panel".reset_saved_time_but_keep_display()
