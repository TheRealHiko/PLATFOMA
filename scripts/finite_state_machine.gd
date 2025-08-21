extends Node2D

var current_state: PlayerState
var previous_state: PlayerState
@onready var debug_label: Label = $"../debug"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"



func _ready():
	print("FSM ready. Children of FSM:")
	for child in get_children():
		print(" - ", child.name, " (script: ", child.get_script(), ")")

		if child is PlayerState:
			child.animation_player = animation_player

	if get_child_count() > 0:
		current_state = get_child(0) as PlayerState
		if current_state:
			previous_state = current_state
			print("Initial state set to: ", current_state.name)
			current_state.enter()
			_update_debug()
		else:
			push_error("⚠ First child is not a PlayerState! Check scripts.")
	else:
		push_error("⚠ FSM has no child states!")

func change_state(state_name: String, anim_name: String = "") -> void:
	print("Attempting to change state to: ", state_name)

	var node = find_child(state_name)
	if node == null:
		push_warning("⚠ State node not found: " + state_name)
		return

	var new_state = node as PlayerState
	if new_state == null:
		push_warning("⚠ Node '" + state_name + "' does not have PlayerState script!")
		return

	if current_state:
		current_state.exit()

	new_state.enter(anim_name)
	previous_state = current_state
	current_state = new_state

	print("✅ Changed state to: ", current_state.name)
	_update_debug()

func _update_debug() -> void:
	if debug_label:
		debug_label.text = "Current State: " + current_state.name
