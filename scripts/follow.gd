extends PlayerState


func _enter_tree() -> void:
	randomize()

func enter(anim_name: String = "") -> void:
	super.enter(anim_name)   # Pass the anim_name up (default "" if unused)
	owner.set_physics_process(true)
	if animation_player:
		animation_player.play("idle")

func exit() -> void:
	super.exit()
	owner.set_physics_process(false)

func transition() -> void:
	var player = get_tree().get_first_node_in_group("player")  # lowercase group
	if player == null:
		return

	var direction = player.global_position - owner.global_position

	if direction.length() < 40:
		get_parent().change_state("Attack")
	elif direction.length() > 150:
		var chance = randi() % 2
		match chance:
			0:
				get_parent().change_state("SpawnMinion")
			1:
				get_parent().change_state("Teleport")
