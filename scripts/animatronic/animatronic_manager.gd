class_name AnimatronicManager
extends Node

enum Animatronics {
	BONNIE,
	CHICA,
	FOXY,
	FREDDY
}
enum Punishment {
	UPGRADES,
	CAMERAS,
	CLICK,
	PASSIVE
}

@onready var jumpscare_manager: JumpscareManager = $JumpscareManager


@export var tokenGame : TokenGame
@export var cameraSystem : CameraSystem
@export var audio_manager : AudioManager
@export var bonnieSpawnTimer : float  = 45.0
@export var chicaSpawnTimer : float = 10000000000.0
@export var foxySpawnTimer : float = 60.0
@export var freddySpawnTimer : float = 60.0

var bonnieEnabled : bool = false
var chicaEnabled : bool = false
var foxyEnabled : bool = false
var freddyEnabled : bool = false


func _ready() -> void:
	$ActivityTimers/Bonnie.wait_time = bonnieSpawnTimer
	$ActivityTimers/Chica.wait_time = chicaSpawnTimer
	$ActivityTimers/Foxy.wait_time = foxySpawnTimer
	$ActivityTimers/Freddy.wait_time = freddySpawnTimer
	for timer : Timer in $ActivityTimers.get_children():
		timer.start()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		tokenGame.tokens = 0
	$Label.text = str($ActivityTimers/Bonnie.time_left)
	$Label2.text = str(bonnieSpawnTimer)
	if Input.is_action_just_pressed("enableFreddy"):
		activate(Animatronics.FREDDY)
		activate(Animatronics.BONNIE)
		activate(Animatronics.FOXY)
	if Input.is_action_just_pressed("forceFreddy"):
		tokenGame.summon_freddy()
	
func activate( animatronic : Animatronics) -> void:
	match animatronic:
		Animatronics.BONNIE:
			bonnieEnabled = true
		Animatronics.CHICA:
			chicaEnabled = true
		Animatronics.FOXY:
			foxyEnabled = true
		Animatronics.FREDDY:
			freddyEnabled = true
func deactivate( animatronic : Animatronics) -> void:
	match animatronic:
		Animatronics.BONNIE:
			bonnieEnabled = false
		Animatronics.CHICA:
			chicaEnabled = false
		Animatronics.FOXY:
			foxyEnabled = false
		Animatronics.FREDDY:
			foxyEnabled = false

func punish (type : Punishment) -> void:
	tokenGame.tokens /= 1.33
	match type:
		Punishment.CAMERAS:
			$PunishmentTimers/camera.start()
			tokenGame.camerasEnabled = false
		Punishment.UPGRADES:
			$PunishmentTimers/upgrades.start()
			tokenGame.upgradesEnabled = false
		Punishment.CLICK:
			$PunishmentTimers/click.start()
			tokenGame.buttonEnabled = false
		Punishment.PASSIVE:
			$PunishmentTimers/passive.start()
			tokenGame.passiveIncomeEnabled = false
func unpunish( type : Punishment) -> void:
	match type:
		Punishment.CAMERAS:
			tokenGame.camerasEnabled = true
		Punishment.UPGRADES:
			tokenGame.upgradesEnabled = true
		Punishment.CLICK:
			tokenGame.buttonEnabled = true
		Punishment.PASSIVE:
			tokenGame.passiveIncomeEnabled = true

func reduceSpawnTime( animatronic : Animatronics ) -> void:
	match animatronic:
		Animatronics.BONNIE:
			bonnieSpawnTimer = max(7, bonnieSpawnTimer-1)
		Animatronics.CHICA:
			chicaSpawnTimer = max(10, chicaSpawnTimer-1)
		Animatronics.FOXY:
			foxySpawnTimer = max(15, foxySpawnTimer-1)
		Animatronics.FREDDY:
			foxySpawnTimer = max(12, freddySpawnTimer-1)
	updateTimers()

func updateTimers() -> void:
	$ActivityTimers/Bonnie.wait_time = max(7, (randf_range(bonnieSpawnTimer-3,bonnieSpawnTimer+3)))
	$ActivityTimers/Chica.wait_time = max(10, (randf_range(chicaSpawnTimer-3,chicaSpawnTimer+3)))
	$ActivityTimers/Foxy.wait_time = max(15, (randf_range(foxySpawnTimer-3,foxySpawnTimer+3)))
	$ActivityTimers/Freddy.wait_time = max(12, (randf_range(freddySpawnTimer-3,freddySpawnTimer+3)))
	


# -=== Animatronic minigame triggers
func _on_bonnie_timeout() -> void:
	if bonnieEnabled:
		if !(cameraSystem.activateBonnie(-1, randf_range(20.0,25.0))):
			$ActivityTimers/Bonnie.start(bonnieSpawnTimer/2)
		else:
			$ActivityTimers/Bonnie.start(randf_range(bonnieSpawnTimer-3, bonnieSpawnTimer+3))
			audio_manager.playSound(audio_manager.SFX.BONNIE_SPAWN)
func _on_chica_timeout() -> void:
	pass # Replace with function body.
func _on_foxy_timeout() -> void:
	if foxyEnabled:
		if !(cameraSystem.activateFoxy(-1, randf_range(5.0,6.0))):
			$ActivityTimers/Foxy.start(foxySpawnTimer/2)
		else:
			$ActivityTimers/Foxy.start(randf_range(foxySpawnTimer-3, foxySpawnTimer+3))
			audio_manager.playSound(audio_manager.SFX.FOXY_SPAWN)
func _on_freddy_timeout() -> void:
	if freddyEnabled:
		audio_manager.playSound(audio_manager.SFX.FREDDY_SPAWN)
		tokenGame.summon_freddy()
		$ActivityTimers/Freddy.start(randf_range(freddySpawnTimer-3, freddySpawnTimer+3))
		
# -=== Animatronic minigame result methods ===-
func _on_camera_system_bonnie_minigame_result(result: bool) -> void:
	if result:
		tokenGame.tokens *= 1.05
	else:
		jumpscare_manager.playJumpscare(jumpscare_manager.Animatronics.BONNIE)
		punish(Punishment.CLICK)
		punish(Punishment.PASSIVE)
func _on_camera_system_foxy_minigame_result(result: bool) -> void:
	if result:
		tokenGame.tokens *= 2.00
	else:
		jumpscare_manager.playJumpscare(jumpscare_manager.Animatronics.FOXY)
		punish(Punishment.CAMERAS)
		punish(Punishment.UPGRADES)
func _on_token_game_freddy_minigame_result(result: bool) -> void:
	if result:
		tokenGame.tokens *= 1.05
	else:
		jumpscare_manager.playJumpscare(jumpscare_manager.Animatronics.FREDDY)
		punish(Punishment.PASSIVE)
		punish(Punishment.UPGRADES)


# -=== Punishment removers ===-
func _on_camera_timeout() -> void:
	unpunish(Punishment.CAMERAS)
func _on_upgrades_timeout() -> void:
	unpunish(Punishment.UPGRADES)
func _on_click_timeout() -> void:
	unpunish(Punishment.CLICK)
func _on_passive_timeout() -> void:
	unpunish(Punishment.PASSIVE)
