extends Node2D


onready var sky := $FieldSky

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_FieldSky_time_change(new_time) -> void:
	match new_time:
		sky.times.MORNING:
			get_tree().call_group("Grows", "grow")
		sky.times.DAY:
			get_tree().call_group("Light", "set_enabled", false)
		sky.times.EVENING:
			get_tree().call_group("Light", "set_enabled", true)
		sky.times.NIGHT:
			pass
			
