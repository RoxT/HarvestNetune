extends VBoxContainer

var inventory:Dictionary setget set_inventory

const ACTION_FORM := "[%s] %s (%s)"
const PLAIN_FORM := "%s (%s)"

const WHAT_DO := {
	"BERRY": {"action": "Eat 1"}
}
const WHAT_CRAFT := {
	"BERRY": {"action": "Use 3", "required": 3, "craft": "PIE"},
	"PLASTBERRY": {"action": "Use 10", "required": 10, "craft": "MINI DRIVE"}
	
}

signal craft(item, count, craft)
signal use(item, action)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_inventory_crafting(value:Dictionary):
	set_inventory(value, WHAT_CRAFT)
	
func set_inventory(value:Dictionary, actions=WHAT_DO):
	inventory = value.duplicate()
	var focus_set := false
	for c in get_children():
		c.queue_free()
	for item in inventory.keys():
		var button := Button.new()
		var action := ""
		if actions.has(item):
			action = actions[item]["action"]
		button.disabled = action.empty()
		if action.empty():
			button.text = PLAIN_FORM % [item, inventory[item]]
			button.disabled = true
		else:
			button.text = ACTION_FORM % [action, item, inventory[item]]
			if actions[item].has("required"):
				if inventory[item] >= actions[item]["required"]:
					button.connect("pressed", self, "_on_Craft_button_pressed", [item])
				else:
					button.disabled = true
			else:
				button.connect("pressed", self, "_on_Use_button_pressed", [item, action])
		add_child(button)
		if !focus_set:
			button.grab_focus()
			focus_set = true
			
func _on_Use_button_pressed(item, action):
	emit_signal("use", item, action)
		
func _on_Craft_button_pressed(item):
	var cost = WHAT_CRAFT[item]["required"]
	var craft = WHAT_CRAFT[item]["craft"]
	emit_signal("craft", item, cost, craft)
	

