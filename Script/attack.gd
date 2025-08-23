extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
var is_attacking: bool = false
var attack_animation_finished: bool = true

func _ready() -> void:
	# Connect the animation finished signal to a function
	$"../AnimatedSprite2D".animation_finished.connect(_on_animation_finished)

func _on_body_entered(body: Node) -> void:
	if not is_attacking and body.is_in_group("Player"):
		is_attacking = true
		attack_animation_finished = false
		$"../AnimatedSprite2D".play("Attack")  # Start attack animation

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		is_attacking = false
		# Only change to walk if the attack animation has finished
		if attack_animation_finished:
			$"../AnimatedSprite2D".play("Walk")  # Change back to idle or walking

func _on_animation_finished() -> void:
	attack_animation_finished = true
	if not is_attacking:
		$"../AnimatedSprite2D".play("Walk")  # Change back to idle or walking if not attacking
