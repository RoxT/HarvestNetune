extends Area2D


onready var bubble := $Label
onready var player := $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubble.hide()
	bubble.text = get_parent().tool_on_bench

func _on_ToolTip_body_entered(body: Node) -> void:
	if body.name == "Player":
		bubble.show()
		player.play("float")


func _on_ToolTip_body_exited(body: Node) -> void:
	if body.name == "Player":
		bubble.hide()
		player.play("RESET")
