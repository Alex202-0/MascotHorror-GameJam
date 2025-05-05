extends VBoxContainer

@onready var token_label: Label = $TokensLabel
@onready var tps_label: Label = $TokensLabel2

func _on_token_game_tokens_changed(amount) -> void:
	token_label.text = str(int(amount)) + " FazTokens"
	

func _on_token_game_tps_changed(tps) -> void:
	tps_label.text = str(int(tps)) + " Tokens per Second"
