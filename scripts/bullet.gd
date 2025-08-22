extends Area2D

var direction: Vector2 = Vector2.RIGHT
var speed: float = 300.0

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):  # only call if safe
		body.take_damage()
	queue_free()  # destroy bullet after hit

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
