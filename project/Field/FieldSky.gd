extends CanvasModulate

onready var timer := $Timer
onready var music := $AudioStreamPlayer
const CHANGE := 0.2
export var S_OF_TRANSITION:float = 15
const COLOR_TRANSITION := 0.5

enum times {
	EARLY_MORNING,
	LATE_MORNING,
	EARLY_DAY,
	LATE_DAY,
	EARLY_EVENING,
	LATE_EVENING,
	EARLY_NIGHT
	LATE_NIGHT
}
export(times) var time = times.LATE_DAY

var s_so_far := 0
var transition := 1/S_OF_TRANSITION

signal time_change(new_time)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if visible:
		timer.start()

func _on_Timer_timeout() -> void:
	match time:
		times.EARLY_MORNING:
			color = color.lightened(1/S_OF_TRANSITION)
			if is_next():
				reset()
		times.LATE_MORNING:
			color = color.lightened(1/S_OF_TRANSITION)
			if is_next():
				reset()
		times.EARLY_DAY:
			color = Color.white
			if is_next():
				reset()
		times.LATE_DAY:
			if is_next():
				color = Color(1.0, 1.0-transition, 1.0-transition)
				reset()
		times.EARLY_EVENING:
			color = color.darkened(1/S_OF_TRANSITION)
			if is_next():
				reset()
		times.LATE_EVENING:
			color = color.darkened(1/S_OF_TRANSITION)
			if is_next():
				reset()
		times.EARLY_NIGHT:
			if is_next():
				color = Color(color.r, color.g, color.b+transition)
				reset()
		times.LATE_NIGHT:
			if is_next():
				color = Color(color.r, color.g, color.b+transition)
				reset()
	s_so_far +=1 

func is_next()->bool:
	return s_so_far >= S_OF_TRANSITION

func reset():
	s_so_far = 0
	time = (time+1)%times.size()
	if !music.is_playing():
		if randi() % 8 < 2:
			music.play()
	emit_signal("time_change", time)

func _on_FieldSky_visibility_changed() -> void:
	if visible:
		timer.start()
	else:
		timer.stop()
		


func _on_AudioStreamPlayer_finished() -> void:
	music.stop()
