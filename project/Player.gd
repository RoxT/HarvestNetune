extends KinematicBody2D


const DEFAULT_SPEED := 5
const FULL_SPEED := 7 
var speed := 5
var ray_dist := 32
onready var animator:AnimatedSprite = $AnimatedSprite
onready var ray := $RayCast2D

var inventory := {}
var famished := false
var hungry := false setget set_hungry
var list_dir := 0.0
var tool_in_hand := ""
var item_held_on_head:Node2D
var direction:Vector2

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
	
	if abs(x) < 0.5 and abs(y) <0.5:
		animator.play("idle")
	else:
		animator.play("walk")
		animator.flip_h = x < 0
		if abs(x) > abs(y):
			if x > 0: 
				#right
				y -= list_dir
			else:
				#left
				y += list_dir
		elif y > 0:
			#down??
			x += list_dir
		else:
			#up??
			x -= list_dir
			
		direction = Vector2(x,y).normalized()
		speed = FULL_SPEED if !famished else DEFAULT_SPEED
		move_and_collide(direction*speed)
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
					elif target.name == "Tool":
						tool_in_hand = target.get_parent().pickup_tool(tool_in_hand)
					elif target.name == "DigSpot":
						if item_held_on_head != null:
							remove_child(item_held_on_head)
							target.add_child(item_held_on_head)
							item_held_on_head.plant()
							item_held_on_head = null
						elif tool_in_hand == "shovel":
							target.add_child(load("res://scenes/Bush.tscn").instance())
					elif target.is_in_group("Pickup-able"):
						var thing = target.pickup(tool_in_hand)
						if thing != null:
							add_child(thing)
							thing.position = Vector2(0, -70)
							item_held_on_head = thing
				else:
					if !item_held_on_head == null:
						item_held_on_head.toss(direction)
						item_held_on_head = null
						animator.play("gesture")
							
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

func set_hungry(value):
	if value == true and hungry == false:
		hungry = true
		list_dir = rand_range(0.1,0.7)
