extends "res://NPCs/TimeChangeFollowPath.gd"

export(Resource) var words_day # Words resource - Array of Strings

const BELLA_NIGHT := "BELLA_NIGHT"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 200
	

func on_early_morning():
	set_physics_process(true)
	forward = true
	body.words = words_day.words

func on_late_evening():
	set_physics_process(true)
	forward = false
	#body.words = words_night.words
	body.words = get_trs(BELLA_NIGHT)
	

	

