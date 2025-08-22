extends PlayerState

@onready var collision = $"../../PlayerDetector/CollisionShape2"
@onready var progress_bar = owner.find_child("ProgressBar")

var player_entered: bool = false:
	set(value):
		player_entered = value
		if collision:
			collision.set_deferred("disabled", value)
		if progress_bar:
			progress_bar.set_deferred("visible", value)

func _ready():
	$"../../PlayerDetector".body_entered.connect(_on_player_detection_body_entered)

func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		player_entered = true

func transition() -> void:
	if player_entered:
		get_parent().change_state("Follow")
