extends Panel

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msecs: int = 0
var killed: bool = false   # <-- new flag

var scene_time_limits = {
	"res://scenes/game2.tscn": 90,
	"res://scenes/game_3.tscn": 150,
	"res://scenes/game.tscn": 180,
	"res://scenes/game4.tscn": 240,
}

@onready var player: CharacterBody2D = $"../../.."
@onready var kill_timer: Timer = $KillTimer

func _process(delta: float) -> void:
	if killed:  # ⬅️ don’t keep running timer after player is dead
		return

	time += delta
	msecs = int(fmod(time, 1) * 1000)
	seconds = int(fmod(time, 60))
	minutes = int(fmod(time, 3600) / 60)

	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d." % seconds
	$Msecs.text = "%03d" % msecs

	var current_scene = get_tree().current_scene.scene_file_path
	if current_scene in scene_time_limits:
		var limit = scene_time_limits[current_scene]
		if time >= limit:
			_kill_player()

func stop() -> void:
	set_process(false)

func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msecs]

func _kill_player() -> void:
	if player and player.is_inside_tree() and not killed:
		killed = true   # ⬅️ prevents re-trigger
		print("Timer Kill triggered")
		GlobalDeathSound.play()
		var col = player.get_node_or_null("CollisionShape2D")
		if col:
			col.queue_free()
		Engine.time_scale = 0.3
		kill_timer.start()




func _on_kill_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
