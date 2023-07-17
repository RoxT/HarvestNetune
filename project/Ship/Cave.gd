extends Node2D

onready var player:= $Player
onready var cave := $CaveTileMap
onready var plataeu := $Plateau

var last_door:Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for door in $Doors.get_children():
		door.connect("body_entered", self, "_on_DoorUp_body_entered", [door])
	plataeu.hide()
	cave.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_DoorUp_body_entered(body: Node, door:Area2D) -> void:
	if body.name == "Player":
		player.pause("bike_up", 1)
		$AnimationPlayer.play("tranistion")
	last_door = door

func toggle_level():
	if cave.visible:
		cave.hide()
		plataeu.show()
	else:
		cave.show()
		plataeu.hide()
	player.position = last_door.position - Vector2(0, -32)
	
