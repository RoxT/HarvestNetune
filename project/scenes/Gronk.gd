extends KinematicBody2D

export(String, FILE, "*.json") var words

const HELLO := ["Hey, you must be new here. I'm Gronk. Your bike broke down? We don't have a lot of parts here, sorry.",
	"You might be here awhile, there's some berries you can grab fom he bushes over there. If you water them they regrow pretty fast. Pretty impressive"]

signal talk (messages)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func talk():
	emit_signal("talk", HELLO.duplicate())

func flip(value:bool):
	$Sprite.flip_h = value
