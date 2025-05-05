extends Button

var _name : String
var cost : int
var button_id: String
var description: String
var amount_owned := 0
var amount_bought := 0
var base_cost: int
var cost_growth: float = 1.2  # How much the price grows each time (can tweak)

func setup(n, _cost, _id, _desc):
	_name = n
	base_cost = _cost         # IMPORTANT: store base cost separately!
	cost = base_cost          # Set initial cost
	button_id = _id
	description = _desc
	_update_text()

func _update_text():
	var cost_str = "%.2f" % cost
	text = "{generator_name} ({amount_owned} owned)\nCost: {cost} FazTokens\n{desc}".format({
		"generator_name": _name,
		"amount_owned": amount_owned,
		"cost": cost_str,
		"desc": description
	})

func _ready():
	pressed.connect(_on_button_down)

func _on_button_down() -> void:
	var token_game : TokenGame = get_tree().get_root().get_node("TokenGame")
	if token_game.tokens >= cost && token_game.upgradesEnabled:
		token_game.tokens -= cost
		amount_owned += 1
		amount_bought += 1
		token_game.animatronicButtonPressed(button_id)

		# Update scalable cost
		cost = int(base_cost * pow(cost_growth, amount_bought))
		_update_text()
