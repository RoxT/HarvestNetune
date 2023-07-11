extends StaticBody2D

export(String) var tool_required

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_in_group("Pickup-able"):
		add_to_group("Pickup-able")
	
func pickup(tool_used:String)->Node2D:
	if tool_used == tool_required:
		#Do stuff
		get_parent().remove_child(self)
		$CollisionShape2D.disabled = true
		return self
	else: return null

func toss(direction:Vector2):
	$AnimationPlayer.play("toss")

func plant():
	position = Vector2(32, 32)
	$CollisionShape2D.disabled = false
