extends VBoxContainer

@onready var token_label: Label = $TokensLabel

func _on_token_game_tokens_changed(amount) -> void:
	token_label.text = str(amount) + " FazTokens"
