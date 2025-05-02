extends Control

const save_path = "user://userdata.save"

@onready var camera_system: CameraSystem = $CameraSystem
var tokens = 0
var amount_per_click = 1
var tokens_per_second := 0.0
var click_mult = 1
var tps_mult = 1
var generator_data := {}
var income_timer := 0.0

signal tokens_changed
signal tps_changed

func _ready() -> void:
	load_data()
	emit_signal("tokens_changed", tokens)
	emit_signal("tps_changed", tokens_per_second)
	

func _process(delta: float) -> void:
	income_timer += delta
	if income_timer >= 1.0:
		tokens += tokens_per_second
		income_timer = 0
		emit_signal("tokens_changed", tokens)

func add_generator_income(generator_id: String, tps: float):
	if generator_id in generator_data:
		generator_data[generator_id] += tps
	else:
		generator_data[generator_id] = tps
	_update_total_income()

func _update_total_income():
	tokens_per_second = 0
	for v in generator_data.values():
		tokens_per_second += v
	emit_signal("tps_changed", tokens_per_second)

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
	print("amount per click: ", amount_per_click * click_mult)
	print("tokens per second: ", tokens_per_second)
	tokens += amount_per_click * click_mult
	emit_signal("tokens_changed", tokens)
	save_data()
	
func apply_upgrade(type: String):
	match type:
		"click_power":
			amount_per_click += 1 * click_mult
			print("Upgraded click power by ", 1 * click_mult)
		"faz_miner":
			tokens_per_second += 1 * tps_mult
		"faz_miner2":
			tokens_per_second += 2 * tps_mult
		"click_doubler":
			click_mult *= 2
			print("Upgraded click mult by ", click_mult)
			print("Upgraded click power by ", 1 * click_mult)
		"double_income":
			tps_mult *= 2
		"unlock_feature":
			$UpgradeContainer/HBoxContainer/MysteryPanel.visible = true
			

func _on_clicker_button_pressed() -> void:
	$UpgradeContainer.visible = false
	$ClickerContainer.visible = true

func _on_upgrade_button_pressed() -> void:
	$UpgradeContainer.visible = true
	$ClickerContainer.visible = false


func _on_camera_button_pressed() -> void:
	camera_system.toggle()
