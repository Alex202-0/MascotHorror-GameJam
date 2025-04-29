extends Control

const save_path = "user://userdata.save"

var tokens = 0
var amount_per_click = 1

signal tokens_changed

func _ready() -> void:
	load_data()
	emit_signal("tokens_changed", tokens)

func save_data():
	var data = {
		"tokens": tokens
	}
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)
	file.close()
	
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var()
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			tokens = data.get("tokens", 0)
	else:
		save_data()

func _on_click_button_button_down() -> void:
	tokens += amount_per_click
	emit_signal("tokens_changed", tokens)
	save_data()
	print(tokens)
