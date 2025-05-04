## A class representing an in-game flashlight that has a max batery, consumption rate a is toggloable.
class_name Flashlight
extends Area2D


@export var defaultMaxDuration : float = 1.5 ## How long the flashlight can be used for.
@onready var flashlight_battery: ProgressBar = $FlashlightBattery
@onready var light : PointLight2D = $PointLight2D
var rechargeRate : float = 1
var overheated : bool = false


func _ready() -> void:
	light.visible = false
	self.monitoring = false
	self.flashlight_battery.max_value = defaultMaxDuration
	self.flashlight_battery.value = defaultMaxDuration
func _process(delta: float) -> void:
	if self.isActive():
		consumeBattery(delta)
	else:
		rechargeBattery(delta*rechargeRate)
		
func isActive() -> bool:
	return self.monitoring
func isUsable() -> bool:
	return !(self.overheated)
func switchOn() -> void:
	if isUsable():
		light.visible = true
		self.monitoring = true
func switchOff() -> void:
	light.visible = false
	self.monitoring = false
func toggle() -> void:
	if isActive():
		switchOff()
	else:
		switchOn()
func increaseRechargeRate(amount : float) -> void:
	self.rechargeRate += amount
func increaseMaxBattery(amount : float) -> void:
	self.flashlight_battery.max_value += amount
func consumeBattery(amount : float) -> void:
	self.flashlight_battery.value = max(0, self.flashlight_battery.value - amount)
	if self.flashlight_battery.value == 0:
		overheated = true
		flashlight_battery.modulate = Color(255,0,0,120)
		switchOff()
func rechargeBattery(amount : float) -> void:
	self.flashlight_battery.value = min( self.flashlight_battery.max_value, self.flashlight_battery.value + amount)
	if overheated && self.flashlight_battery.value == self.flashlight_battery.max_value:
		overheated = false
		flashlight_battery.modulate = Color.YELLOW

	
 
