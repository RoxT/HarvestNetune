extends Node

const EARLY_MORNING := "EARLY_MORNING"
const EARLY_DAY := "EARLY_DAY" 
const LATE_EVENING := "LATE_EVENING"

var speed := 100
var forward := true
var path_follow:PathFollow2D
var body:CollisionObject2D
var path:Path2D

export(NodePath) var path_follow_value
export(NodePath) var starting_path

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path_follow = get_node(path_follow_value)
	path = get_node(starting_path)
	body = path_follow.get_child(0)
	if path_follow.get_parent() != path:
		move_body(path)
	
	add_group("on_early_morning", EARLY_MORNING)
	add_group("on_early_day", EARLY_DAY)
	add_group("on_late_evening", LATE_EVENING)
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	var stop
	if forward:
		path_follow.offset += speed * delta
		stop = path_follow.unit_offset != 1
	else:
		path_follow.offset -= speed * delta
		stop = path_follow.unit_offset != 0
	set_physics_process(stop)

func add_group(method:String, group:String):
	if has_method(method):
		if !is_in_group(group):
			add_to_group(group)
			
func move_body(new:Path2D):
	path = new
	path_follow.get_parent().remove_child(path_follow)
	path.add_child(body)
	
func get_trs(key:String):
	var words_set := []
	var i := 1
	for j in 10:
		var new_words = tr(key + str(i))
		if new_words == key + str(i):
			if words_set.empty(): push_warning(key + " produced no text")
			return words_set
		else:
			words_set.append(new_words)
	push_error("Tranlation loop went higher than 10")
	
