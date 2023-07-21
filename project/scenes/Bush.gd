extends StaticBody2D
class_name Bush

enum LEVEL {SPROUT, TEEN, MATURE, BERRY}
export(LEVEL) var level setget set_level
export(String, "BERRY", "PLASTBERRY") var berry_type = "BERRY"
export(String) var tool_required = "shovel"

const PATH := "res://textures/bushes/%s.png"

onready var sprite := $Sprite

var loaded := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var b := "redberrybush" if berry_type == "BERRY" else "plastberrybush"
	sprite.texture = load(PATH % b)
	sprite.frame = level
	loaded = true
	
func set_level(value:int):
	level = value
	if loaded:
		sprite.frame = level
	
func harvest():
	if level == LEVEL.BERRY:
		set_level(level-1)
		return berry_type
	else:
		return null
		
func grow():
	if level < LEVEL.BERRY:
		set_level(level+1)

func pickup(tool_used:String)->Node2D:
	if tool_used == tool_required:
		get_parent().remove_child(self)
		$CollisionShape2D.disabled = true
		return self
	else: return null

func toss(direction:Vector2):
	$AnimationPlayer.play("toss")

func plant():
	position = Vector2(32, 32)
	$CollisionShape2D.disabled = false

