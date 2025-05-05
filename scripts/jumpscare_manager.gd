class_name JumpscareManager
extends Control

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var reboot_screen: ColorRect = $rebootScreen
@onready var reboot_timer: Timer = $rebootScreen/rebootTimer
@onready var animation_player: AnimationPlayer = $rebootScreen/AnimationPlayer

enum Animatronics {
	BONNIE,
	CHICA,
	FOXY,
	FREDDY
}

var jumpscareVideos : Dictionary[Animatronics, VideoStream]

func _ready() -> void:
	jumpscareVideos = {
		Animatronics.BONNIE : load("res://assets/jumpscares/bonnieJumpscare.ogv"),
		Animatronics.CHICA : load("res://assets/jumpscares/chicaJumpscare.ogv"),
		Animatronics.FOXY : load("res://assets/jumpscares/foxyJumpscare.ogv"),
		Animatronics.FREDDY : load("res://assets/jumpscares/freddyJumpscare.ogv"),
	}



func playJumpscare(animatronic : Animatronics) -> void:
	self.visible = true
	video_stream_player.visible = true
	video_stream_player.stream = jumpscareVideos[animatronic]
	video_stream_player.play()

func _on_video_stream_player_finished() -> void:
	video_stream_player.stop()
	video_stream_player.visible = false
	reboot_screen.visible = true
	reboot_timer.start()
	animation_player.play("progress")

func _on_reboot_timer_timeout() -> void:
	reboot_screen.visible = false
	self.visible = false
	
