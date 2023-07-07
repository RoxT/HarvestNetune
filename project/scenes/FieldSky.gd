extends CanvasModulate

onready var timer := $Timer
const CHANGE := 0.2
export var S_OF_TRANSITION:float = 15.0
const COLOR_TRANSITION := 0.5

enum times {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var time = times.DAY
var s_so_far := 0
var transition := 1/S_OF_TRANSITION

signal time_change(new_time)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if visible:
		timer.start()

func _on_Timer_timeout() -> void:
	match time:
		times.MORNING:
			color = color.lightened(1/S_OF_TRANSITION)
			if is_next():
				reset()
		times.DAY:
			color = Color.white
			if is_next():
				color = Color(1.0, 1.0-transition, 1.0-transition)
				reset()
		times.EVENING:
			color = color.darkened(1/S_OF_TRANSITION)
			if is_next():
				reset()
		times.NIGHT:
			if is_next():
				color = Color(color.r, color.g, color.b+transition)
				reset()
	s_so_far +=1 

func is_next()->bool:
	return s_so_far >= S_OF_TRANSITION

func reset():
	s_so_far = 0
	time = (time+1)%times.size()
	emit_signal("time_change", time)

func _on_FieldSky_visibility_changed() -> void:
	if visible:
		timer.start()
	else:
		timer.stop()
		
