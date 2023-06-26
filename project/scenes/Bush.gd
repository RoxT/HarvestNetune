extends StaticBody2D

enum LEVEL {SPROUT, TEEN, MATURE, BERRY}
export(LEVEL) var level setget set_level

const BERRY = "BERRY"

onready var sprite := $Sprite

var loaded := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.frame = level
	loaded = true
	
func set_level(value:int):
	level = value
	if loaded:
		sprite.frame = level
	
func harvest():
	if level == LEVEL.BERRY:
		set_level(level-1)
		return BERRY
	else:
		return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
