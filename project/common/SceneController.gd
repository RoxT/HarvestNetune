extends Node2D


onready var gronk := $Field/Gronk
onready var dialog := $DialogLayer
onready var player := $Field/Player
onready var HUD := $HUDLayer

var active_scene:Node2D

var inventory := {}

const PATH := "user://SaveData"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save_dir = Directory.new()
	if !save_dir.dir_exists("user://SaveData"):
		var err = save_dir.make_dir(PATH)
		if err != OK:
			push_error("Could not make SaveData: " + str(err))
	active_scene = $Field
	var errs := []
	for npc in get_tree().get_nodes_in_group("NPC"):
		errs.append(npc.connect("talk", self, "_on_talk"))
	errs.append(dialog.connect("talked", self, "_on_talked"))
	for n in get_tree().get_nodes_in_group("Doors"):
		errs.append(n.connect("door_entered", self, "_on_DoorTo_door_entered"))
		print(n.name + " connected from " + active_scene.name)
	errs.append_array(connect_player())
	for e in errs:
		if e != OK: push_error(str(e))
	$Debug.visible = OS.has_virtual_keyboard()

func _on_talk(messages:Array, header:String):
	dialog.show_dialog(messages, header)

func _on_talked():
	player.stop_talking()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("home"):
		get_tree().set_input_as_handled()
		var bike_loc := ResourceLoader.load("user://SaveData/Bike.tres") as SaveRes
		var where_is_bike = bike_loc.data["last_scene"]
		if where_is_bike == active_scene.name:
			_on_DoorTo_door_entered("", bike_loc.last_pos)
		else:
			if where_is_bike == "Field":
				_on_DoorTo_door_entered("res://Field.tscn", bike_loc.last_pos)
			elif where_is_bike == "RoadWest":
				_on_DoorTo_door_entered("res://Field.tscn", bike_loc.last_pos)
	elif event.is_action_pressed("ui_cancel"):
		var window := $HUDLayer/Help
		window.visible = !window.visible
			

func _cleanup_scene():
	get_tree().call_group("NPC", "disconnect", "talk", self, "_on_talk")
	get_tree().call_group("Door", "disconnect", "door_entered", self, "_on_DoorTo_door_entered")
	connect_player(true)
	
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
	errs.append_array(connect_player())
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

func _on_HUDLayer_famished(fell_below:bool) -> void:
	player.famished = fell_below


func _on_HUDLayer_hungry(fell_below:bool) -> void:
	player.hungry = fell_below

func _on_ate():
	HUD.ate()
	
func _on_tool_picked_up(tool_name:String):
	HUD.tool_picked_up(tool_name)
	
func connect_player(disconnect:=false)->Array:
	var errs := []
	if disconnect:
		player.disconnect("ate", self, "_on_ate")
		player.disconnect("tool_picked_up", self, "_on_tool_picked_up")
		player.disconnect("add_to_inventory", self, "_on_add_to_inventory")
		player.disconnect("bed", self, "_on_Player_bed")
		player.disconnect("craft", self, "_on_Player_craft")
	else:
		errs.append(player.connect("ate", self, "_on_ate"))
		errs.append(player.connect("tool_picked_up", self, "_on_tool_picked_up"))
		errs.append(player.connect("add_to_inventory", self, "_on_add_to_inventory"))
		errs.append(player.connect("bed", self, "_on_Player_bed"))
		errs.append(player.connect("craft", self, "_on_Player_craft"))
	return errs
	
func _on_add_to_inventory(item:String):
	if inventory.has(item):
		inventory[item] += 1
	else:
		inventory[item] = 1

func _on_remove_from_inventory(item, count) -> void:
	if inventory.has(item):
		inventory[item] -= count
		
	else:
		push_error("Tried to remove " + item + "but there is none")

func _on_Player_bed():
	$HUDLayer/ColorRect/AnimationPlayer.play("sleep")

func sleep():
	get_tree().call_group("Paths", "sleep")
	$Field/FieldSky.color = $Field/FieldSky.morning_light
	$Field/FieldSky.call_deferred("reset", 0)

func _on_Player_craft():
	$HUDLayer/InventoryButton.pressed = true
	$HUDLayer/InventoryContainer.set_inventory_crafting(inventory)
	$CraftLayer.show()
	player.pause_override = true
	

func _on_InventoryButton_toggled(button_pressed: bool) -> void:
	player.pause_override = button_pressed
	var container := $HUDLayer/InventoryContainer
	if button_pressed:
		container.inventory = inventory
	else:
		container.inventory = {}
		$CraftLayer.hide()

func _on_InventoryContainer_craft(item, count, craft) -> void:
	if inventory.has(item):
		inventory[item] -= count
		_on_add_to_inventory(craft)
		$HUDLayer/InventoryContainer.set_inventory_crafting(inventory)
		
	else:
		push_error("Tried to remove " + item + "but there is none")
		assert(false)


func _on_InventoryContainer_use(item, action) -> void:
	inventory[item] -= 1
	$HUDLayer/InventoryContainer.inventory = inventory
