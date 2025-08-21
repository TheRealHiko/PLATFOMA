extends PlayerState   # Assuming "State" is actually your PlayerState base

@onready var collision: CollisionShape2D = $"../../PlayerDetector/CollisionShape2"
@onready var progress_bar: Control = owner.find_child("BossHealth")

# Backing variable with setter (Godot 4 style, no setget)
var _player_entered: bool = false:
	set(value):
		_player_entered = value
		if collision:
			collision.set_deferred("disabled", value)
		if progress_bar:
			progress_bar.set_deferred("visible", value)

func _ready() -> void:
	# Connect signal dynamically so you don’t forget in the editor
	var detector = $"../../PlayerDetector"
	if detector:
		detector.body_entered.connect(_on_player_detector_body_entered)

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):   # Optional: only trigger on player
		_player_entered = true   # This calls the setter automatically
		print("DETECTED BODY:", body.name, "on layer", body.collision_layer)

func transition():
	if _player_entered:
		get_parent().change_state("Follow")
