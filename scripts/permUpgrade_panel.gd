extends VBoxContainer

@onready var permanent_list = $ScrollContainer/PermUpgradeList
var PermanentButtonScene = preload("res://scenes/permanent_button.tscn")

# Define your upgrades here
var upgrade_defs = [
	{
		"name": "Click++",
		"cost": 10,
		"description": "Doubles your click power",
		"type": "click_doubler"
	},
	{
		"name": "Turbo Tokens",
		"cost": 50,
		"description": "Double passive income",
		"type": "double_income"
	},
	{
		"name": "Mystery Unlocked",
		"cost": 100,
		"description": "Unlocks the mystery panel",
		"type": "unlock_feature"
	}
]

func _ready():
	for upgrade in upgrade_defs:
		add_upgrade(upgrade["name"], upgrade["cost"], upgrade["description"], upgrade["type"])

func add_upgrade(name: String, cost: int, description: String, upgrade_type: String):
	var btn = PermanentButtonScene.instantiate()
	btn.setup(name, cost, description, upgrade_type)
	permanent_list.add_child(btn)
