extends KinematicBody2D


var speed := 5
var ray_dist := 32
onready var animator := $AnimatedSprite
onready var ray := $RayCast2D

var inventory := {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if animator.animation == "gesture": return
	var x := Input.get_axis("ui_left", "ui_right")
	var y := Input.get_axis("ui_up", "ui_down")
	var direction := Vector2(x,y).normalized()
	move_and_collide(direction*speed)
	if abs(x) < 0.5 and abs(y) <0.5:
		animator.play("idle")
	else:
		animator.play("walk")
		animator.flip_h = x < 0
		ray.cast_to = ray_dist*direction


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
			if animator.animation == "idle" or animator.animation == "walk":
				ray.force_raycast_update()
				var target:Node = ray.get_collider()
				if target != null:
					if target.is_in_group("Bush"):
						animator.play("gesture", true)
						var item:String = target.harvest()
						if item != null:
							if inventory.has(item):
								inventory[item] += 1
							else:
								inventory[item] = 1
					elif target.is_in_group("NPC"):
						animator.play("talk")
						target.flip(target.position.x > position.x)
						target.talk()

func stop_talking():
	animator.play("idle")

func _on_AnimatedSprite_animation_finished() -> void:
	if animator.animation == "gesture":
		animator.play("idle")
