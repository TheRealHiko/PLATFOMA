extends PlayerState

func enter(anim_name: String = "skill") -> void:
	super.enter(anim_name)
	if animation_player:
		animation_player.play("death")

func boss_slained() -> void:
	if animation_player:
		animation_player.play("boss_slained")
