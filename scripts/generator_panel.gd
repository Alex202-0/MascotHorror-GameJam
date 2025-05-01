extends VBoxContainer

@onready var generator_list = $ScrollContainer/GeneratorList
var GeneratorButtonScene = preload("res://scenes/generator_button.tscn")

var generator_defs = [
	{
		"name": "Clicker.exe",
		"cost": 5,
		"tps": 0.0,
		"id": "click_power",
		"desc": "Increases click power by 1."
	},
	{
		"name": "FazMiner.exe",
		"cost": 20,
		"tps": 1.0,
		"id": "faz_miner",
		"desc": "Mines 1 FazToken per second automatically"
	},
	{
		"name": "FazMiner 2.0.exe",
		"cost": 100,
		"tps": 5.0,
		"id": "faz_miner2",
		"desc": "A better token miner. Mines 2 per second."
	}
]

func _ready():
	for gen in generator_defs:
		add_generator(gen["name"], gen["cost"], gen["tps"], gen["id"], gen["desc"])

func add_generator(name, cost, tps, id, desc):
	var btn = GeneratorButtonScene.instantiate()
	btn.setup(name, cost, tps, id, desc)
	generator_list.add_child(btn)
