@tool
extends Control

@export var world_index: int = 1

func _ready() -> void:
	$Label.text = " World " +str(world_index)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$Label.text = " World " +str(world_index)
