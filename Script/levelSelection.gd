extends Control

func _on_tutorial_level_pressed() -> void:
	AudioManager.play_select()
	get_tree().change_scene_to_file("res://Scenes/TutorialLevel.tscn") 

func _on_level_1_pressed() -> void:
	AudioManager.play_select()
	get_tree().change_scene_to_file("res://Scenes/1stLevel.tscn") 

func _on_level_2_pressed() -> void:
	AudioManager.play_select()
	get_tree().change_scene_to_file("res://Scenes/2ndLevel.tscn") 

func _on_return_to_main_menu_pressed() -> void:
	AudioManager.play_select()
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn") 
