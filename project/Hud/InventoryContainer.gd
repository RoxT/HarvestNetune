extends VBoxContainer

var inventory:Dictionary setget set_inventory

const ACTION_FORM := "[%s] %s (%s)"
const PLAIN_FORM := "%s (%s)"

const WHAT_DO := {
	"BERRY": {"action": "Eat 1"}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
func set_inventory(value:Dictionary):
	inventory = value
	var focus_set := false
	for c in get_children():
		c.queue_free()
	for item in inventory.keys():
		var button := Button.new()
		var action := ""
		if WHAT_DO.has(item):
			action = WHAT_DO[item]["action"]
		button.disabled = action.empty()
		if action.empty():
			button.text = PLAIN_FORM % [item, inventory[item]]
			button.disabled = true
		else:
			button.text = ACTION_FORM % [action, item, inventory[item]]
		add_child(button)
		if !focus_set:
			button.grab_focus()
			focus_set = true
		
	

