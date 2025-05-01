extends Button

var upgrade_name: String
var cost: int
var description: String
var upgrade_type: String  # Used to determine what this upgrade does

func setup(_name, _cost, _desc, _type):
	upgrade_name = _name
	cost = _cost
	description = _desc
	upgrade_type = _type

	_update_text()

func _update_text():
	var cost_str = "%.2f" % cost
	text = "{upgrade_name}\nCost: {cost} FazTokens\n{description}".format({
		"upgrade_name": upgrade_name,
		"cost": cost_str,
		"description": description
	})

func _ready():
	pressed.connect(_on_button_down)

func _on_button_down() -> void:
	var token_game = get_tree().get_root().get_node("TokenGame")

	if token_game.tokens >= cost:
		token_game.tokens -= cost
		token_game.emit_signal("tokens_changed", token_game.tokens)
		
		# Apply the upgrade effect
		token_game.apply_upgrade(upgrade_type)

		# One-time use: remove the button
		queue_free()
