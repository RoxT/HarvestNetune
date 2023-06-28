tool
extends KinematicBody2D

export(Resource) var words_r # Words resource - Array of Strings
var words:Array

signal talk (messages)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(words_r)
	if !is_in_group("NPC"):
		add_to_group("NPC")


func talk():
	words_r  = words_r as WordsR
	words = words_r.words
	emit_signal("talk", words.duplicate())

func flip(value:bool):
	$Sprite.flip_h = value
	
func _get_configuration_warning() -> String:
	if not self is KinematicBody2D:
		return "Script must be added to KinematicBody2D"
	var sprite := get_node_or_null("Sprite") as Sprite
	if not sprite:
		return "This node needs a Sprite child node named Sprite"
	if not words_r is WordsR:
		return "This node requires a WordsR Resource"
	
	return ""
