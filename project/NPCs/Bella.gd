extends "res://NPCs/NPC.gd"


#("EARLY_MORNING", "on_early_morning")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_in_group(EARLY_MORNING):
		add_to_group(EARLY_MORNING)


func on_early_morning():
	pass
