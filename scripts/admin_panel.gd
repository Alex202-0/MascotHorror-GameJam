extends VBoxContainer

@onready var token_input = $LineEdit
@onready var confirm_button = $ConfirmButton

func _ready():
	confirm_button.pressed.connect(_on_confirm_pressed)

func _on_confirm_pressed():
	var amount = token_input.text.to_int()
	if amount > 0:
		var token_game = get_tree().get_root().get_node("TokenGame")
		token_game.tokens += amount
		token_game.emit_signal("tokens_changed", token_game.tokens)
		token_game.save_data()
		print("Admin gave ", amount, " tokens!")
	else:
		print("Invalid amount entered.")
