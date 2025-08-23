extends AnimatedSprite2D

func play_beat():
	if sprite_frames and sprite_frames.has_animation("Beating"):
		animation = "Beating"
		play()

func play_lose():
	if sprite_frames and sprite_frames.has_animation("Lose"):
		animation = "Lose"
		play()
