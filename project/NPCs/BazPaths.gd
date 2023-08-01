extends "res://NPCs/TimeChangeFollowPath.gd"

const BAZ_BRIDGE := "BAZ_BRIDGE"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Path2D/PathFollow2D/Baz.words = get_trs(BAZ_BRIDGE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
