extends Area2D

@export var end_level_ui_path: NodePath  # Drag your EndLevel node in the inspector

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.start_auto_run()  # optional: make player auto-run
		if $"../GameUI/EndLevel" and $"../GameUI/EndLevel".has_method("end_level"):
			$"../GameUI/EndLevel".end_level()
