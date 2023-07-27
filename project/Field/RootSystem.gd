extends Area2D

export(String, "BERRY", "PLASTBERRY") var berry_type = "BERRY"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func grow():
	if get_node_or_null("Bush") == null:
		var bush  = preload("res://Field/Bush.tscn").instance()
		bush.berry_type = berry_type
		add_child(bush)
		
		
		
