extends VBoxContainer

@onready var generator_list = $ScrollContainer/GeneratorList
var GeneratorButtonScene = preload("res://scenes/generator_button.tscn")

# === Generator Definitions ===
var generator_defs = [
	{
		"name": "Clicker.exe",
		"cost": 15,
		"tps": 0.1,
		"id": "click_power",
		"desc": "Increases click power by 1.",
		"unlock_requirement": null
	},
	{
		"name": "FazMiner.exe",
		"cost": 20,
		"tps": 1.0,
		"id": "faz_miner",
		"desc": "Mines 1 FazToken per second automatically.",
		"unlock_requirement": null
	},
	{
		"name": "FazMiner 2.0.exe",
		"cost": 100,
		"tps": 5.0,
		"id": "faz_miner2",
		"desc": "An upgraded miner. Mines 5 per second.",
		"unlock_requirement": {
			"type": "tokens_earned",
			"amount": 50
		}
	},
	{
		"name": "Autobot.exe",
		"cost": 250,
		"tps": 15.0,
		"id": "autobot",
		"desc": "Self-operating bot that boosts token production.",
		"unlock_requirement": {
			"type": "tokens_earned",
			"amount": 500
		}
	},
	{
		"name": "ServerRack.exe",
		"cost": 1000,
		"tps": 50.0,
		"id": "server_rack",
		"desc": "Old Fazbear servers still churning tokens.",
		"unlock_requirement": {
			"type": "tokens_earned",
			"amount": 2500
		}
	},
	{
		"name": "AI.FreddyNet",
		"cost": 5000,
		"tps": 250.0,
		"id": "freddynet",
		"desc": "Advanced AI system mining FazTokens at insane speeds.",
		"unlock_requirement": {
			"type": "tokens_earned",
			"amount": 10000
		}
	},
	{
		"name": "GhostProtocol.exe",
		"cost": 20000,
		"tps": 1200.0,
		"id": "ghost_protocol",
		"desc": "Anomalous process that siphons energy from lost Fazbear systems.",
		"unlock_requirement": {
			"type": "tokens_earned",
			"amount": 50000
		}
	},
	{
		"name": "QuantumCore.sys",
		"cost": 100000,
		"tps": 8000.0,
		"id": "quantum_core",
		"desc": "Unstable but massively powerful Fazbear quantum server.",
		"unlock_requirement": {
			"type": "tokens_earned",
			"amount": 200000
		}
	}
]


var locked_generators = []

func _ready():
	for gen in generator_defs:
		if gen.get("unlock_requirement", null) == null:
			spawn_generator(gen)
		else:
			locked_generators.append(gen)

func spawn_generator(gen_data):
	var btn = GeneratorButtonScene.instantiate()
	btn.setup(
		gen_data["name"],
		gen_data["cost"],
		gen_data["tps"],
		gen_data["id"],
		gen_data["desc"]
	)
	generator_list.add_child(btn)

func check_generator_unlocks():
	for gen in locked_generators.duplicate():
		if generator_unlocked(gen):
			spawn_generator(gen)
			locked_generators.erase(gen)

func generator_unlocked(gen) -> bool:
	var req = gen.get("unlock_requirement", null)
	if req == null:
		return true

	match req.type:
		"tokens_earned":
			return $"../../..".tokens >= req.amount
	return false
