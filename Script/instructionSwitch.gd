extends Node

var show_first_panel = true

@onready var player = $Player

func _ready():
	$GameUI/BlueControls.visible = true
	$GameUI/RedControls.visible = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and player.health != 1:
		show_first_panel = !show_first_panel
		$GameUI/BlueControls.visible = show_first_panel
		$GameUI/RedControls.visible = not show_first_panel
