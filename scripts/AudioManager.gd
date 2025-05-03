class_name AudioManager
extends Node


var currentBackgroundMusic : AudioStreamPlayer

enum BM {
	UPBEAT,
	CREEPY
}

enum SFX {
	FAZTOKEN_CLICKED, UPGRADE_BUTTON_CLICKED, CAMERA_CLICKED, GENERIC_BUTTON,
	BONNIE_SPAWN, CHICA_SPAWN, FOXY_SPAWN, FREDDY_SPAWN,
	BONNIE_JUMPSCARE, CHICA_JUMPSCARE, FOXY_JUMPSCARE, FREDDY_JUMPSCARE
}

var musicMap : Dictionary[BM, AudioStreamPlayer]

var sfxMap : Dictionary[SFX, AudioStreamPlayer]


func _ready() -> void:
	musicMap  = {
	BM.UPBEAT : $BackgroundMusic/upbeat,
	BM.CREEPY : $BackgroundMusic/cameraStatic
	}
	sfxMap = {
	SFX.FAZTOKEN_CLICKED : $SFX/onFazTokenClick, SFX.UPGRADE_BUTTON_CLICKED : $SFX/onUpgradeButtonClick, SFX.CAMERA_CLICKED : $SFX/onCameraButtonClicked, SFX.GENERIC_BUTTON : $SFX/onGenericButtonPressed,
	SFX.BONNIE_SPAWN : $SFX/onBonnieGuitarSpawn, SFX.CHICA_SPAWN : $SFX/onChicaSpawn, SFX.FOXY_SPAWN : $SFX/onFoxySpawn, SFX.FREDDY_SPAWN : $SFX/onFreddySpawn, 
	SFX.BONNIE_JUMPSCARE : $SFX/onBonnieJumpscare, SFX.CHICA_JUMPSCARE : $SFX/onChicaJumpscare, SFX.FOXY_JUMPSCARE : $SFX/onFoxyJumpscare, SFX.FREDDY_JUMPSCARE : $SFX/onFreddyJumpscare
}


func playMusic(musicType : BM) -> void:
	if currentBackgroundMusic:
		currentBackgroundMusic.stop()
		currentBackgroundMusic = musicMap[musicType]
		currentBackgroundMusic.play()
	else:
		currentBackgroundMusic = musicMap[musicType]
		currentBackgroundMusic.play()


func playSound( sfx : SFX) -> void:
	sfxMap[sfx].play()

func _on_upbeat_finished() -> void:
	$BackgroundMusic/upbeat.play()
func _on_camera_static_finished() -> void:
	$BackgroundMusic/cameraStatic.play()
