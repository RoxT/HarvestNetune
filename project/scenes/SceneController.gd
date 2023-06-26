extends Node2D


onready var gronk := $Gronk
onready var dialog := $DialogLayer
onready var player := $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var errs := []
	errs.append(gronk.connect("talk", self, "_on_talk"))
	errs.append($Sidon.connect("talk", self, "_on_talk"))
	errs.append(dialog.connect("talked", self, "_on_talked"))
	for e in errs:
		if e != OK: push_error(str(e))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_talk(messages:Array):
	dialog.show_dialog(messages)

func _on_talked():
	player.stop_talking()
