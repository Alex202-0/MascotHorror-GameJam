
class_name TokenGame
extends Control

const save_path = "user://userdata.save"

@onready var camera_system: CameraSystem = $CameraSystem
@onready var audio_manager: AudioManager = $AudioManager

signal freddyMinigameResult(result : bool)

var tokens = 0
var amount_per_click = 1
var tokens_per_second := 0.0
var click_mult = 1
var tps_mult = 1
var generator_data := {}
var generator_base_tps = {}
var income_timer := 0.0

# Punishment variables
var buttonEnabled : bool = true
var passiveIncomeEnabled : bool = true
var ugradesEnabled : bool = true
var camerasEnabled : bool = true


# === Freddy System ===
var freddy_spawn_timer: Timer
var freddy_count := 0

signal tokens_changed
signal tps_changed

func _ready() -> void:
	load_data()
	emit_signal("tokens_changed", tokens)
	emit_signal("tps_changed", tokens_per_second)
	audio_manager.playMusic(audio_manager.BM.UPBEAT)
	camera_system.audio_manager = audio_manager
	

func _process(delta: float) -> void:
	income_timer += delta
	if income_timer >= 1.0 && passiveIncomeEnabled:
		tokens += tokens_per_second
		income_timer = 0
		emit_signal("tokens_changed", tokens)
		get_node("UpgradeContainer/HBoxContainer/PermUpgradePanel").check_unlocks()
		get_node("UpgradeContainer/HBoxContainer/GeneratorPanel").check_generator_unlocks()

func add_generator_income(generator_id: String, tps: float):
	if generator_id in generator_data:
		generator_data[generator_id] += 1
	else:
		generator_data[generator_id] = 1
		generator_base_tps[generator_id] = tps
	_update_total_income()

func get_generator_owned(generator_id: String) -> int:
	if generator_id in generator_data:
		return int(generator_data[generator_id])  # Or however you're counting them
	return 0


func _update_total_income():
	tokens_per_second = 0
	for generator_id in generator_data.keys():
		var owned = generator_data[generator_id]
		var base_tps = generator_base_tps.get(generator_id, 0)
		tokens_per_second += base_tps * owned * tps_mult
	emit_signal("tps_changed", tokens_per_second)


func save_data():
	var data = {
		"tokens": tokens,
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
	if buttonEnabled:
		audio_manager.playSound(audio_manager.SFX.FAZTOKEN_CLICKED)
		print("amount per click: ", amount_per_click * click_mult)
		print("tokens per second: ", tokens_per_second)
		tokens += amount_per_click * click_mult
		emit_signal("tokens_changed", tokens)
		save_data()
	
func apply_upgrade(type: String):
	if ugradesEnabled:
		audio_manager.playSound(audio_manager.SFX.UPGRADE_BUTTON_CLICKED)
		
		match type:
			"click_power":
				amount_per_click += 1 * click_mult
			
			"faz_miner":
				# No need to add TPS directly anymore
				pass
			
			"fazminer_boost":
				if "faz_miner" in generator_base_tps:
					generator_base_tps["faz_miner"] *= 2
					print("FazMiner base TPS doubled to ", generator_base_tps["faz_miner"])
			
			"faz_miner2":
				pass
			
			"fazminer2_boost":
				if "faz_miner2" in generator_base_tps:
					generator_base_tps["faz_miner2"] *= 2
					print("FazMiner 2.0 base TPS doubled to ", generator_base_tps["faz_miner2"])
			
			"autobot":
				pass
			
			"autobot_boost":
				if "autobot" in generator_base_tps:
					generator_base_tps["autobot"] *= 2
					print("Autobot base TPS doubled to ", generator_base_tps["autobot"])
			
			"server_rack":
				pass
			
			"serverrack_boost":
				if "server_rack" in generator_base_tps:
					generator_base_tps["server_rack"] *= 2
					print("ServerRack base TPS doubled to ", generator_base_tps["server_rack"])
			
			"freddynet":
				pass
			
			"freddynet_boost":
				if "freddynet" in generator_base_tps:
					generator_base_tps["freddynet"] *= 2
					print("FreddyNet base TPS doubled to ", generator_base_tps["freddynet"])
			
			"ghost_protocol":
				pass
			
			"ghostprotocol_boost":
				if "ghost_protocol" in generator_base_tps:
					generator_base_tps["ghost_protocol"] *= 2
					print("GhostProtocol base TPS doubled to ", generator_base_tps["ghost_protocol"])
			
			"quantum_core":
				pass
			
			"quantumcore_boost":
				if "quantum_core" in generator_base_tps:
					generator_base_tps["quantum_core"] *= 2
					print("QuantumCore base TPS doubled to ", generator_base_tps["quantum_core"])
			
			"click_doubler":
				click_mult *= 2
			
			"double_income":
				tps_mult *= 2
			"flashlight_battery":
				camera_system.flashlight.increaseMaxBattery(0.10)
			"flashlight_recharge":
				camera_system.flashlight.increaseRechargeRate(0.05)
			"unlock_feature":
				$UpgradeContainer/HBoxContainer/MysteryPanel.visible = true
	
	# Always recalculate after any upgrade
	_update_total_income()

func _on_clicker_button_pressed() -> void:
	$UpgradeContainer.visible = false
	$ClickerContainer.visible = true

func _on_upgrade_button_pressed() -> void:
	$UpgradeContainer.visible = true
	$ClickerContainer.visible = false


func _on_camera_button_pressed() -> void:
	if camerasEnabled:
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

func _on_freddy_button_pressed() -> void:
	if $ClickerContainer.visible:
		summon_freddy()
