extends Node2D

onready var sky := $FieldSky

enum DAYS_OF_WEEK {
	MON,
	WED,
	FRI
}

var inventory := {}
var day := 0
var day_of_week := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_FieldSky_time_change(sky.time)

func _on_FieldSky_time_change(new_time) -> void:
	match new_time:
		sky.times.EARLY_MORNING:
			print(". - * Morning * - .")
			get_tree().call_group("EARLY_MORNING", "on_early_morning")
		sky.times.LATE_MORNING:
			get_tree().call_group("Light", "set_enabled", false)
			get_tree().call_group("LATE_MORNING", "on_late_morning")
			get_tree().call_group("Grows", "grow")
		sky.times.EARLY_DAY:
			get_tree().call_group("EARLY_DAY", "on_early_day")
		sky.times.LATE_EVENING:
			get_tree().call_group("Light", "set_enabled", true)
			get_tree().call_group("LATE_EVENING", "on_late_evening")
		sky.times.EARLY_NIGHT:
			get_tree().call_group("EARLY_NIGHT", "on_early_night")
			
