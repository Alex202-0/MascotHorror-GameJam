extends Button

signal cameraButtonPressed(id : int)
var id : int

func _ready() -> void:
	id = int(name)
