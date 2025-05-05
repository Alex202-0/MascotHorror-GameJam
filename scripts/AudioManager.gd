## A class that handles all audio being played in the game.
class_name AudioManager
extends Node

## Current background music that is playing.
var currentBackgroundMusic : AudioStreamPlayer


## Enumerator containing all possible background music.
enum BM {
	UPBEAT,
	CREEPY
}

## An enumerator containing all posible sound effects.
enum SFX {
	FAZTOKEN_CLICKED, UPGRADE_BUTTON_CLICKED, CAMERA_CLICKED, GENERIC_BUTTON,
	BONNIE_SPAWN, CHICA_SPAWN, FOXY_SPAWN, FREDDY_SPAWN,
	BONNIE_JUMPSCARE, CHICA_JUMPSCARE, FOXY_JUMPSCARE, FREDDY_JUMPSCARE
}

## A map that pairs each enumerator with its respective AudioStreamPlayer for music.
var musicMap : Dictionary[BM, AudioStreamPlayer]
## A map that pairs each enumerator with its respective AudioStreamPlayer for sound effects.
var sfxMap : Dictionary[SFX, AudioStreamPlayer]


func _ready() -> void:
	# Initialize the maps
	musicMap  = {
	BM.UPBEAT : $BackgroundMusic/upbeat,
	BM.CREEPY : $BackgroundMusic/cameraStatic
	}
	sfxMap = {
	SFX.FAZTOKEN_CLICKED : $SFX/onFazTokenClick, SFX.UPGRADE_BUTTON_CLICKED : $SFX/onUpgradeButtonClick, SFX.CAMERA_CLICKED : $SFX/onCameraButtonClicked, SFX.GENERIC_BUTTON : $SFX/onGenericButtonPressed,
	SFX.BONNIE_SPAWN : $SFX/onBonnieGuitarSpawn, SFX.CHICA_SPAWN : $SFX/onChicaSpawn, SFX.FOXY_SPAWN : $SFX/onFoxySpawn, SFX.FREDDY_SPAWN : $SFX/onFreddySpawn, 
	SFX.BONNIE_JUMPSCARE : $SFX/onBonnieJumpscare, SFX.CHICA_JUMPSCARE : $SFX/onChicaJumpscare, SFX.FOXY_JUMPSCARE : $SFX/onFoxyJumpscare, SFX.FREDDY_JUMPSCARE : $SFX/onFreddyJumpscare
}


## A function that plays the passed in music. For all available music tracks,
## write AudioManager.BM. , this will show a list of all the possible enumerators.
func playMusic(musicType : BM) -> void:
	if currentBackgroundMusic:
		currentBackgroundMusic.stop()
		currentBackgroundMusic = musicMap[musicType]
		currentBackgroundMusic.play()
	else:
		currentBackgroundMusic = musicMap[musicType]
		currentBackgroundMusic.play()

## A function that plays the passed in music. For all available sound effects,
## write AudioManager.SFX. , this will show a list of all the possible enumerators.
func playSound( sfx : SFX) -> void:
	sfxMap[sfx].play()


# Music looping signals
func _on_upbeat_finished() -> void:
	$BackgroundMusic/upbeat.play()
func _on_camera_static_finished() -> void:
	$BackgroundMusic/cameraStatic.play()
