extends Panel

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msecs: int = 0
var killed: bool = false   # prevent multiple kills

# Scene-specific limits
var scene_time_limits = {
	"res://scenes/game2.tscn": 60,
	"res://scenes/game_3.tscn": 150,
	"res://scenes/game.tscn": 180,
	"res://scenes/game4.tscn": 240,
}

@onready var player: CharacterBody2D = $"../../.."
@onready var kill_timer: Timer = $KillTimer

func _ready() -> void:
	load_time()

func _process(delta: float) -> void:
	if killed:
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
			_reset_timer_and_kill()

func stop() -> void:
	set_process(false)

func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msecs]

# --- Kill flow when time runs out ---
func _reset_timer_and_kill() -> void:
	if killed:
		return
	killed = true
	print("Timer expired -> reset timer and kill player")

	# Reset the saved timer
	get_tree().set_meta("timer_value", 0.0)

	if player and player.is_inside_tree():
		GlobalDeathSound.play()
		var col = player.get_node_or_null("CollisionShape2D")
		if col:
			col.queue_free()
		Engine.time_scale = 0.3
		kill_timer.start()

# --- Persistence helpers ---
func save_time() -> void:
	get_tree().set_meta("timer_value", time)

func load_time() -> void:
	if get_tree().has_meta("timer_value"):
		time = get_tree().get_meta("timer_value")

# --- Triggered when kill_timer ends (after time-out kill) ---
func _on_kill_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
func reset_saved_time_but_keep_display() -> void:
	# reset stored value
	get_tree().set_meta("timer_value", 0.0)
	# DO NOT touch `time` or labels -> UI stays at last shown value
