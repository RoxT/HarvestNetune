extends CanvasLayer


onready var text:RichTextLabel = $Panel/Text
export(Array, String) var messages

signal talked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		get_tree().set_input_as_handled()
		next()

func show_dialog(new_messages:Array):
	show()
	set_process_input(true)
	messages = new_messages
	next()
	
func next():
	text.clear()
	if messages.empty():
		hide()
		set_process_input(false)
		emit_signal("talked")
	else:
		text.add_text(messages.pop_front())
	
