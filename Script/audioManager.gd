extends Node2D

@export var mute: bool = false

func _ready():
	if not mute:
		play_music()

func play_music():
	if not mute:
		$Music.play()

func play_jump() -> void:
	if not mute:
		$Jump.play()

func play_slash() -> void:
	if not mute:
		$Slash.play()

func play_hurt() -> void:
	if not mute:
		$Hurt.play()
	
func play_healed() -> void:
	if not mute:
		$Healed.play()

func play_run() -> void:
	if not mute:
		$Run.play()
		
func play_select() -> void:
	if not mute:
		$Select.play()
