extends Area2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func grow():
	if get_node_or_null("Bush") == null:
		add_child(preload("res://scenes/Bush.tscn").instance())
		
		
