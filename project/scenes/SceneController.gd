extends Node2D


onready var gronk := $Field/Gronk
onready var dialog := $DialogLayer
onready var player := $Field/Player

var active_scene:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var errs := []
	for npc in get_tree().get_nodes_in_group("NPC"):
		errs.append(npc.connect("talk", self, "_on_talk"))
	errs.append(dialog.connect("talked", self, "_on_talked"))
	errs.append($Field/DoorToCave.connect("door_entered", self, "_on_DoorTo_door_entered"))
	for e in errs:
		if e != OK: push_error(str(e))
	active_scene = $Field
	$Debug.visible = OS.has_virtual_keyboard()

func _on_talk(messages:Array):
	dialog.show_dialog(messages)

func _on_talked():
	player.stop_talking()

func _cleanup_scene():
	get_tree().call_group("NPC", "disconnect", "talk", self, "_on_talk")
	get_tree().call_group("Door", "disconnect", "door_entered", self, "_on_DoorTo_door_entered")
	
func _setup_scene():
	add_child(active_scene)
	var npcs := get_tree().get_nodes_in_group("NPC")
	if npcs.empty():
		print("No NPCs found in " + active_scene.name)
	var errs := []
	for n in npcs:
		errs.append(n.connect("talk", self, "_on_talk"))
		print(n.name + " has entered " + active_scene.name)
	for n in get_tree().get_nodes_in_group("Doors"):
		errs.append(n.connect("door_entered", self, "_on_DoorTo_door_entered"))
		print(n.name + " connected from " + active_scene.name)
	for e in errs:
		if e != OK: push_error(str(e))

func _on_DoorTo_door_entered(target_scene_path:String, coordinates:Vector2) -> void:
	if !target_scene_path.empty():
		_cleanup_scene()
		call_deferred("remove_child", active_scene)
		
		active_scene = load(target_scene_path).instance()
		
		call_deferred("_setup_scene")
		
		player = active_scene.get_node("Player")
	if coordinates != Vector2.ZERO:
		player.position = coordinates

func _on_HUDLayer_famished() -> void:
	player.famished = true


func _on_HUDLayer_hungry() -> void:
	player.hungry = true
