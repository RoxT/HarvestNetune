extends KinematicBody2D

var words:Array

signal talk (messages, header)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_in_group("NPC"):
		add_to_group("NPC")

func flip(value:bool):
	$Sprite.flip_h = value

func talk():
	emit_signal("talk", words.duplicate(), name)
