extends Control

@onready var timer_label = $VBoxContainer/TimerLabel
@onready var demand_label = $VBoxContainer/DemandLabel
@onready var pay_button = $VBoxContainer/PayButton

var demand_amount: int
var countdown: float = 10.0 # seconds to pay

var main_scene: TokenGame # We'll set this when creating the popup.

func _ready():
	set_process(true)

func _process(delta):
	countdown -= delta
	timer_label.text = "Time Left: %.1f" % countdown

	if countdown <= 0:
		_on_timeout()

func setup(demand: int, main_ref: Node):
	demand_amount = demand
	main_scene = main_ref
	demand_label.text = "Freddy demands %d FazTokens!" % demand

func _on_pay_button_pressed():
	print(main_scene)
	if main_scene.tokens >= demand_amount:
		main_scene.tokens -= demand_amount
		main_scene.freddyMinigameResult.emit(true)
		main_scene.emit_signal("tokens_changed", main_scene.tokens)
		queue_free()
	else:
		_on_timeout()

func _on_timeout():
	main_scene.freddyMinigameResult.emit(false)
	queue_free()
