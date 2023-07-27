extends Node


onready var body := $EARLY_MORNING/PathFollow2D/Slime

export(Resource) var words_day # Words resource - Array of Strings
export(Resource) var words_night # Words resource - Array of Strings

onready var path_follow := $EARLY_MORNING/PathFollow2D
var speed := 100
var forward := true

const EARLY_MORNING := "EARLY_MORNING"
const EARLY_DAY := "EARLY_DAY" 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(words_day)
	assert(words_night)

	if !is_in_group(EARLY_MORNING):
		add_to_group(EARLY_MORNING)
	if !is_in_group(EARLY_DAY):
		add_to_group(EARLY_DAY)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var stop
	if forward:
		path_follow.offset += speed * delta
		stop = path_follow.unit_offset != 1
	else:
		path_follow.offset -= speed * delta
		stop = path_follow.unit_offset != 0
	set_physics_process(stop)
	
func on_early_morning():
	set_physics_process(true)
	forward = true
	body.words = words_day.words

func on_early_day():
	set_physics_process(true)
	forward = false
	body.words = words_night.words
	
