extends KinematicBody2D

export(Resource) var words_r # Words resource - Array of Strings
var words:Array

signal talk (messages)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(words_r)


func talk():
	words_r  = words_r as WordsR
	words = words_r.words
	emit_signal("talk", words.duplicate())

func flip(value:bool):
	$Sprite.flip_h = value
