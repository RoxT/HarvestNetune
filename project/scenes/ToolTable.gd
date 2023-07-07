tool
extends Sprite

const PATH := "res://textures/tools/%s.png"

export(String) var tool_on_bench setget set_tool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_tool(value:String):
	if !value.empty():
		var t = load(PATH % value)
		if t == null:
			texture = load(PATH % "error")
			tool_on_bench = ""
			
		else:
			texture = t
			tool_on_bench = value
	else:
		texture = load(PATH % "empty")
		tool_on_bench = value
		
func pickup_tool(new_tool)->String:
	var old_tool = tool_on_bench
	set_tool(new_tool)
	return old_tool
