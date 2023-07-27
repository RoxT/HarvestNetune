extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		pass

func _on_Whip_body_entered(body: Node) -> void:
	body = body as KinematicBody2D
	body.modulate.r = 255


func _on_Whip_body_exited(body: Node) -> void:
	body = body as KinematicBody2D
	body.modulate.r = 0
