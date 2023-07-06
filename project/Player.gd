extends KinematicBody2D


var speed := 5
var ray_dist := 32
onready var animator:AnimatedSprite = $AnimatedSprite
onready var ray := $RayCast2D

var inventory := {}

var parent_placeholder:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if animator.animation == "gesture": return
	if parent_placeholder != null: return
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
			var animation := animator.animation
			if animation == "idle" or animation == "walk":
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
					elif target.name == "Bike":
						target.start()
						parent_placeholder = get_parent()
						get_parent().remove_child(self)
						position = Vector2(0,0)
						$CollisionShape2D.disabled = true
						target.add_child(self)
						animator.stop()
			elif animation.begins_with("bike"):
				var bike = get_parent()
				ray.cast_to = Vector2(-64, 0)
				ray.add_exception(bike)
				ray.force_raycast_update()
				var obs = ray.get_collider()
				if obs != null:
					print(obs.name + " is in the way")
					var wh = load("res://scenes/Whisper.tscn").instance()
					add_child(wh)
					wh.get_node("AnimationPlayer").play("go")
				else:
					bike.remove_child(self)
					position = bike.position + Vector2(-64, 0)
					parent_placeholder.add_child(self)
					parent_placeholder = null
					$CollisionShape2D.disabled = false
					animator.play("idle")
					bike.stop()
				ray.remove_exception(bike)

func stop_talking():
	animator.play("idle")

func _on_AnimatedSprite_animation_finished() -> void:
	if animator.animation == "gesture":
		animator.play("idle")

