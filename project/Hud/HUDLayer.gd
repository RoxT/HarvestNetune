extends CanvasLayer

onready var food:ProgressBar = $Food
onready var tool_sprite := $ToolSprite
const PATH := "res://textures/tools/%s.png"

const FAMISHED := 60
const HUNGRY := 20
const DELTA := 3
const BERRY_FILLING := 20

signal hungry(fell_below)
signal famished(fell_below)

func _ready() -> void:
	food.value = food.max_value

func _on_Food_Timer_timeout() -> void:
	food.value = food.value - DELTA
	if food.value < HUNGRY:
		emit_signal("hungry", true)
	elif food.value < FAMISHED:
		emit_signal("famished", true)
	
func ate():
	food.value += BERRY_FILLING
	emit_signal("hungry", food.value < HUNGRY)
	emit_signal("famished", food.value < FAMISHED)
	
func tool_picked_up(tool_name:String):
	if tool_name.empty():
		tool_name = "empty"
	tool_sprite.texture = load(PATH % tool_name)
