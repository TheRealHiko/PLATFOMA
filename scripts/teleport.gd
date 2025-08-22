extends PlayerState

var can_transition: bool = false

func enter(anim_name: String = "skill") -> void:
	super.enter(anim_name)
	owner.set_physics_process(false)
	if animation_player:
		animation_player.play(anim_name)
	await animation_player.animation_finished
	teleport()
	can_transition = true
	transition()

func teleport() -> void:
	if player:
		owner.global_position = player.global_position + Vector2.LEFT * 32
		
		print("Boss teleported!")

func transition() -> void:
	if can_transition:
		get_parent().change_state("Attack")
		can_transition = false
