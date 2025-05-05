extends Button

var generator_name: String
var cost: int
var tokens_per_second: float
var generator_id: String
var description: String
var amount_owned := 0
var amount_bought := 0
var base_cost: int
var cost_growth: float = 1.2  # How much the price grows each time (can tweak)

func setup(_name, _cost, _tps, _id, _desc):
	generator_name = _name
	base_cost = _cost         # IMPORTANT: store base cost separately!
	cost = base_cost          # Set initial cost
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
		amount_bought += 1
		
		# NEW: Always use updated base TPS
		var real_tps = token_game.generator_base_tps.get(generator_id, tokens_per_second)
		
		token_game.add_generator_income(generator_id, real_tps)
		token_game.apply_upgrade(generator_id)

		# Update scalable cost
		cost = int(base_cost * pow(cost_growth, amount_bought))


		_update_text()
		token_game.emit_signal("tokens_changed", token_game.tokens)
