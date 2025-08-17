extends Area2D

@export var instant_kill := false
@export var damage := 1

func _ready() -> void:
	# make sure the signal is connected
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		print("KillZone2 triggered by Player")

		if instant_kill:
			GlobalDeathSound.play()
			body.die()
		else:
			body.take_damage(damage)
