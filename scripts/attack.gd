extends PlayerState

func enter(anim_name: String = "skill") -> void:
	super.enter(anim_name)
	combo()

func attack(move: String = "1") -> void:
	if animation_player:
		animation_player.play("attack_" + move)
		await animation_player.animation_finished

func combo() -> void:
	var move_set = ["1", "1", "2"]
	for move in move_set:
		await attack(move)
	# loop combo continuously
	combo()

func transition() -> void:
	if not player:
		return
	if (player.global_position - owner.global_position).length() > 40:
		get_parent().change_state("Follow")

 
