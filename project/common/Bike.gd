extends KinematicBody2D

onready var anim_player := $AnimationPlayer
onready var sprite := $Sprite
onready var headlamp := $Light2D
var player:KinematicBody2D


const MAX_SPEED := 15
const ACCELERATION := 0.3
var speed := 0.0
var last_dir
var stats:Bike_Stats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats = Bike_Stats.new()
	stats.last_pos = position
	if get_node_or_null("Debug") != null:
		$Debug.queue_free()
	set_physics_process(false)

func _enter_tree() -> void:
	if stats != null:
		position = stats.last_pos

func _exit_tree() -> void:
	stats.last_pos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if player == null:
		player = $Player
	
	var x := Input.get_axis("ui_left", "ui_right")
	var y := Input.get_axis("ui_up", "ui_down")
	var direction := Vector2(x,y).normalized()
	
	match direction:
		Vector2.UP:
			sprite.play("up")
			speed = speed + ACCELERATION
			player.animator.play("bike_up")
			headlamp.rotation_degrees = -90
		Vector2.DOWN:
			sprite.play("down")
			speed = speed + ACCELERATION
			player.animator.play("bike_down")
			headlamp.rotation_degrees = 90
		Vector2.RIGHT:
			sprite.play("right")
			sprite.flip_h = false
			speed = speed + ACCELERATION
			player.animator.flip_h = false
			player.animator.flip_h = false
			player.animator.play("bike_right")
			headlamp.rotation_degrees = 0
		Vector2.LEFT:
			sprite.play("right")
			sprite.flip_h = true
			speed = speed + ACCELERATION
			player.animator.flip_h = true
			player.animator.play("bike_right")
			player.animator.flip_h = true
			headlamp.rotation_degrees = 180
			
		Vector2.ZERO:
			speed = speed - ACCELERATION
			direction
	
	speed = clamp(speed, 0, MAX_SPEED)
	if speed > 0:
		direction = direction if direction != Vector2.ZERO else last_dir
	move_and_collide(direction*speed)
	last_dir = direction

func start():
	anim_player.play("running")
	set_physics_process(true)
	speed = 0
	
func stop():
	anim_player.play("RESET")
	set_physics_process(false)
