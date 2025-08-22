extends PlayerState

@export var speed: float = 37.0
@export var attack_distance: float = 50.0
@export var teleport_distance: float = 125.0

var can_tp_minion: bool = true

func _physics_process(delta: float) -> void:
	if not player:
		return
	var direction = (player.global_position - owner.global_position).normalized()
	owner.global_position += direction * speed * delta
	if animation_player and not animation_player.is_playing():
		animation_player.play("walk")

func transition() -> void:
	if not player:
		return
	var dist = (player.global_position - owner.global_position).length()
	if dist < attack_distance:
		get_parent().change_state("Attack")
	elif dist > teleport_distance and can_tp_minion:
		get_parent().change_state("SpawnMinion")
		can_tp_minion = false
	elif dist <= teleport_distance:
		can_tp_minion = true
