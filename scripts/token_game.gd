extends Control

const save_path = "user://userdata.save"

@onready var camera_system: CameraSystem = $CameraSystem
@onready var audio_manager: AudioManager = $AudioManager


var tokens = 0
var amount_per_click = 1
var tokens_per_second := 0.0
var click_mult = 1
var tps_mult = 1
var generator_data := {}
var income_timer := 0.0



# === Freddy System ===
var freddy_spawn_timer: Timer
var freddy_count := 0

signal tokens_changed
signal tps_changed

func _ready() -> void:
	load_data()
	emit_signal("tokens_changed", tokens)
	emit_signal("tps_changed", tokens_per_second)
	freddy_spawn_timer = Timer.new()
	add_child(freddy_spawn_timer)
	freddy_spawn_timer.timeout.connect(_on_freddy_attack)
	audio_manager.playMusic(audio_manager.BM.UPBEAT)
	camera_system.audio_manager = audio_manager
	

func _process(delta: float) -> void:
	income_timer += delta
	if income_timer >= 1.0:
		tokens += tokens_per_second
		income_timer = 0
		emit_signal("tokens_changed", tokens)
	if audio_manager.currentBackgroundMusic:
		$Label.text = audio_manager.currentBackgroundMusic.name

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
		"tokens": tokens,
		"amount_per_click" : amount_per_click,
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
	audio_manager.playSound(audio_manager.SFX.FAZTOKEN_CLICKED)
	print("amount per click: ", amount_per_click * click_mult)
	print("tokens per second: ", tokens_per_second)
	tokens += amount_per_click * click_mult
	emit_signal("tokens_changed", tokens)
	save_data()
	
func apply_upgrade(type: String):
	audio_manager.playSound(audio_manager.SFX.UPGRADE_BUTTON_CLICKED)
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
		"flashlight_battery":
			camera_system.flashlight.increaseMaxBattery(0.10)
		"flashlight_recharge":
			camera_system.flashlight.increaseRechargeRate(0.05)
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
	
# Freddy Stuff	
func summon_freddy():
	var freddy_popup = preload("res://scenes/animatronics/freddy.tscn").instantiate()
	add_child(freddy_popup) # <- ADD FIRST!
	var demand = calculate_freddy_tax()
	print("Current self is: ", self)
	freddy_popup.setup(demand, self)

func calculate_freddy_tax() -> int:
	var manual_rate = amount_per_click * click_mult
	var auto_rate = tokens_per_second
	var bonus = 100 # Change later.
	return manual_rate + auto_rate + bonus

func schedule_next_freddy_attack():
	var delay = randf_range(20.0, 40.0) / max(1, freddy_count)
	freddy_spawn_timer.start(delay)

func _on_freddy_attack():
	summon_freddy()
	schedule_next_freddy_attack()

func temp_game_over():
	print("TEMP GAME OVER triggered by Freddy!")
	# Here you could later open a GameOver screen or reset.
	



func _on_freddy_button_pressed() -> void:
	if $ClickerContainer.visible:
		summon_freddy()
