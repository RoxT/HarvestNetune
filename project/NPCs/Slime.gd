extends "res://NPCs/TimeChangeFollowPath.gd"



export(Resource) var words_day # Words resource - Array of Strings
export(Resource) var words_night # Words resource - Array of Strings


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	forward = true
	body.words = words_night.words
	assert(words_day)
	assert(words_night)
	
	
func on_early_day():
	set_physics_process(true)
	forward = true
	body.words = words_day.words

func on_early_night():
	set_physics_process(true)
	forward = false
	body.words = words_night.words
	
