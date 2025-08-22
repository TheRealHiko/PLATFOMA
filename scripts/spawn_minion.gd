extends PlayerState

@export var minion_node: PackedScene
var can_transition: bool = false

func enter(anim_name: String = "summon") -> void:
	super.enter(anim_name)
	if animation_player:
		animation_player.play(anim_name)
	await animation_player.animation_finished
	spawn_minion()
	can_transition = true
	transition()

func spawn_minion() -> void:
	if not minion_node:
		push_error("Minion node not assigned!")
		return
	var minion = minion_node.instantiate()
	minion.global_position = owner.global_position + Vector2(40, -40)
	get_tree().current_scene.add_child(minion)
	print("Minion spawned!")

func transition() -> void:
	if can_transition:
		get_parent().change_state("Teleport")
		can_transition = false
