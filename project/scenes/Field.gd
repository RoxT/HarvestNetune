extends Node2D


onready var sky := $FieldSky

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_FieldSky_time_change(sky.time)
	place()

func _on_FieldSky_time_change(new_time) -> void:
	match new_time:
		sky.times.DAY:
			get_tree().call_group("Light", "set_enabled", false)
		sky.times.EVENING:
			get_tree().call_group("Light", "set_enabled", true)
		sky.times.NIGHT:
			pass
		sky.times.MORNING:
			#Do everything
			print(". - * Morning * - .")
			get_tree().call_group("Grows", "grow")
			place()

func place():
	var plasteels := 0
	for spot in $Garden.get_children():
		for c in spot.get_children():
			if c.name.begins_with("Bush"):
				if c.berry_type == "PLASTEELBERRY":
					plasteels += 1
	if plasteels < 2:
		$Bella.position = Vector2(-192, -1152)
		print("Bella to forest")
	else:
		$Bella.position = Vector2(896, -64)
		print("Bella to garden")
	
