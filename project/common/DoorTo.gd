extends Area2D

export(String, FILE, "*.tscn") var door_to
export(Vector2) var warp_to

signal door_entered(target_scene, coordinates)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _get_configuration_warning() -> String:
	if not door_to:
		return "Door Node requires a path to a packed scene to transport to"
	if not is_in_group("Door"):
		return "Must be added to group Door"
	else:
		return ""


func _on_DoorToCave_body_entered(_body: Node) -> void:
	if door_to == null and warp_to == null: push_warning(name + " has no destination")
	emit_signal("door_entered", door_to, warp_to)
