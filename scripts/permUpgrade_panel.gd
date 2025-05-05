extends VBoxContainer

@onready var permanent_list = $ScrollContainer/PermUpgradeList
var PermanentButtonScene = preload("res://scenes/permanent_button.tscn")

# Define your upgrades here
var upgrade_defs = [

	{
		"name": "Click++",
		"cost": 10,
		"description": "Doubles your click power",
		"type": "click_doubler",
		"unlock_requirement": null  # Always available
	},
	{
		"name": "Turbo Tokens",
		"cost": 50,
		"description": "Double passive income",
		"type": "double_income",
		"unlock_requirement": {
			"type": "tokens_earned",
			"amount": 100
		}
	},
	{
		"name": "Mystery Unlocked",
		"cost": 100,
		"description": "Unlocks the mystery panel",
		"type": "unlock_feature",
		"unlock_requirement": {
			"type": "tokens_earned",
			"amount": 200
		}
	},
	{
		"name": "FazMiner Boost",
		"cost": 200,
		"description": "Doubles FazMiner's efficiency!",
		"type": "fazminer_boost",
		"unlock_requirement": {
			"type": "amount_owned",
			"generator_id": "faz_miner",
			"amount": 2
		}
	},
	{
		"name": "FazMiner 2.0 Boost",
		"cost": 1000,
		"description": "Doubles FazMiner 2.0 efficiency!",
		"type": "fazminer2_boost",
		"unlock_requirement": {
			"type": "amount_owned",
			"generator_id": "faz_miner2",
			"amount": 5
		}
	},
	{
		"name": "Autobot Overclock",
		"cost": 2500,
		"description": "Autobots work twice as fast!",
		"type": "autobot_boost",
		"unlock_requirement": {
			"type": "amount_owned",
			"generator_id": "autobot",
			"amount": 5
		}
	},
	{
		"name": "Server Rack Optimization",
		"cost": 5000,
		"description": "ServerRacks double their token output!",
		"type": "serverrack_boost",
		"unlock_requirement": {
			"type": "amount_owned",
			"generator_id": "server_rack",
			"amount": 5
		}
	},
	{
		"name": "FreddyNet Deep Learning",
		"cost": 10000,
		"description": "FreddyNet AI mines tokens twice as fast!",
		"type": "freddynet_boost",
		"unlock_requirement": {
			"type": "amount_owned",
			"generator_id": "freddynet",
			"amount": 5
		}
	},
	{
		"name": "GhostProtocol Unbound",
		"cost": 25000,
		"description": "GhostProtocol gains massive efficiency (×2)!",
		"type": "ghostprotocol_boost",
		"unlock_requirement": {
			"type": "amount_owned",
			"generator_id": "ghost_protocol",
			"amount": 5
		}
	},
	{
		"name": "QuantumCore Overload",
		"cost": 100000,
		"description": "QuantumCores now output twice as much!",
		"type": "quantumcore_boost",
		"unlock_requirement": {
			"type": "amount_owned",
			"generator_id": "quantum_core",
			"amount": 2
		}
	}
]


var locked_upgrades = []

func _ready():
	for upgrade in upgrade_defs:
		if upgrade.get("unlock_requirement") == null:
			spawn_upgrade(upgrade)
		else:
			locked_upgrades.append(upgrade)

func add_upgrade(name: String, cost: int, description: String, upgrade_type: String):
	var btn = PermanentButtonScene.instantiate()
	btn.setup(name, cost, description, upgrade_type)
	permanent_list.add_child(btn)

func spawn_upgrade(upgrade_data):
	add_upgrade(upgrade_data["name"], upgrade_data["cost"], upgrade_data["description"], upgrade_data["type"])

func check_unlocks():
	for upgrade in locked_upgrades.duplicate():
		if upgrade_has_unlocked(upgrade):
			spawn_upgrade(upgrade)
			locked_upgrades.erase(upgrade)

func upgrade_has_unlocked(upgrade) -> bool:
	var req = upgrade.get("unlock_requirement", null)
	if req == null:
		return true
	
	match req.type:
		"tokens_earned":
			return $"../../..".tokens >= req.amount
		"amount_owned":
			var generator_id = req.generator_id
			var required_amount = req.amount
			return $"../../..".get_generator_owned(generator_id) >= required_amount
	
	return false
