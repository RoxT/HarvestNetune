class_name SaveRes
extends Resource

export(Vector2) var last_pos setget set_last_pos
export(Dictionary) var data := {} setget set_data
export(String) var obj_name

const bad_pos: = Vector2(-999999,-999999)

func _init(new_name:="", new_pos:=bad_pos, new_data:={}) -> void:
	if new_name.empty():
		obj_name = "MISSINGNO"
	if new_pos == bad_pos: last_pos = Vector2.ZERO
	
	obj_name = new_name
	last_pos = new_pos
	data = new_data
	
func save():
	pass
	#var err := ResourceSaver.save(path(obj_name), self)
	#if err != OK:
#		push_error("Error Saving " + obj_name + ": " + str(err))
#		assert(false)

static func load_save(get_obj_name:String):
	if ResourceLoader.exists(path(get_obj_name)):
		return ResourceLoader.load(path(get_obj_name)) as SaveRes
	else:
		return null

static func path(get_obj_name:String)->String:
	
	return "user://SaveData/%s.tres" % get_obj_name

func set_last_pos(value:Vector2):
	last_pos = value
	save()

func set_data(value:Dictionary):
	data = value
	save()
	
func update_data(key:String, value):
	data[key] = value
	save()
