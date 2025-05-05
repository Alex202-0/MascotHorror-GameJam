extends VBoxContainer

@onready var animatronicUpgradeList : VBoxContainer = $ScrollContainer/MysteryPanel
var animatronicButton: PackedScene = preload("res://scenes/animatronic_button.tscn")

# === Generator Definitions ===
var animatronicButtons : Array = [
	{
		"name": "Bonnie",
		"cost": 2500,
		"id": "bonnie",
		"desc": "Unlocks the next camera. Bonnie's guitar will spawn at a random, even, unlocked room. The more Bonnie upgrades, more spawn rate.",
	},
	{
		"name": "Freddy",
		"cost": 5000,
		"id": "freddy",
		"desc": "Makes Super Tokens appear more often inside of the cameras. Freddy will ask the player for money... better pay up.",
	},
	{
		"name": "Foxy",
		"cost": 7500,
		"id": "foxy",
		"desc": "Enables Foxy in the cameras. Find him with your Flashlight to DUPLICATE your current Token count.",

	}
]


func _ready() -> void:
	for button in animatronicButtons:
		spawn_generator(button)

			

func spawn_generator(gen_data: Dictionary) -> void:
	var btn = animatronicButton.instantiate()
	btn.setup(
		gen_data["name"],
		gen_data["cost"],
		gen_data["id"],
		gen_data["desc"]
	)
	animatronicUpgradeList.add_child(btn)
