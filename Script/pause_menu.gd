extends Control

@onready var pause_menu = $"."

func _ready():
	get_tree().paused = false
	$".".visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	$".".visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	$".".visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func testEsc():
	if Input.is_action_just_pressed("Pause") and get_tree().paused == false:
		AudioManager.play_select()
		pause()

	elif Input.is_action_just_pressed("Pause") and get_tree().paused == true:
		AudioManager.play_select()
		resume()

func _on_button_pressed() -> void:
	resume()
	AudioManager.play_select()

func _on_button_2_pressed() -> void:
	resume()
	AudioManager.play_select()
	get_tree().reload_current_scene()

func _on_button_3_pressed() -> void:
	AudioManager.play_select()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = false
	$".".visible = false
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn") 

func _process(delta):
	testEsc()
