extends Control

func _ready() -> void:
	visible = false

func end_level() -> void:
	visible = true
	AudioManager.play_select()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_retry_button_pressed() -> void:
	visible = false
	AudioManager.play_select()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed() -> void:
	visible = false
	AudioManager.play_select()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
