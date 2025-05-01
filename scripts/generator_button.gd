extends Button

var generator_name: String
var cost: int
var tokens_per_second: float
var generator_id: String
var description: String
var amount_owned := 0

func setup(_name, _cost, _tps, _id, _desc):
	generator_name = _name
	cost = _cost
	tokens_per_second = _tps
	generator_id = _id
	description = _desc

	_update_text()

func _update_text():
	var cost_str = "%.2f" % cost
	text = "{generator_name} ({amount_owned} owned)\nCost: {cost} FazTokens\n{desc}".format({
		"generator_name": generator_name,
		"amount_owned": amount_owned,
		"cost": cost_str,
		"desc": description
	})

func _ready():
	pressed.connect(_on_button_down)

func _on_button_down() -> void:
	var token_game = get_tree().get_root().get_node("TokenGame")
	if token_game.tokens >= cost:
		token_game.tokens -= cost
		amount_owned += 1
		token_game.emit_signal("tokens_changed", token_game.tokens)
		token_game.apply_upgrade(generator_id)
		token_game.add_generator_income(generator_id, tokens_per_second)
		_update_text()
