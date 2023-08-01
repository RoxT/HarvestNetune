class_name Bike_Stats
extends Resource

export var last_pos:Vector2 setget set_pos

func save():
	ResourceSaver.save("user://bike_stats.tres", self)

func set_pos(value):
	last_pos = value
	save()
