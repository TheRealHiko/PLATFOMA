extends Node2D

@onready var timer_panel: Panel = $Player/Camera2D/CanvasLayer/Panel

func _input(event):
	if event.is_action_pressed("exit"):
		# First reset stored timer value
		if timer_panel:
			timer_panel.reset_saved_time_but_keep_display()
			print("Timer data reset to 0, display unchanged")

		# Then exit to world select
		get_tree().change_scene_to_file("res://scenes/world_select.tscn")
