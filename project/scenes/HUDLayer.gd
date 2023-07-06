extends CanvasLayer

onready var food:ProgressBar = $Food

const FAMISHED := 60
const HUNGRY := 20
const DELTA := 3

signal hungry
signal famished

func _ready() -> void:
	food.value = food.max_value

func _on_Food_Timer_timeout() -> void:
	food.value = food.value - DELTA
	if food.value < HUNGRY:
		emit_signal("hungry")
	elif food.value < FAMISHED:
		emit_signal("famished")
	
