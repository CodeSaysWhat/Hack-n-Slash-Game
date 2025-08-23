extends CharacterBody2D

const GRAVITY = 500.0
const SPEED = 50.0

var direction := -1
var is_hurt := false
var is_dead := false
var health: int = 3

@export var damage_knockback: Vector2 = Vector2(50, 0)

func _ready() -> void:
	$AnimatedSprite2D.play("Walk")

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if not is_hurt:
		move_character()
		detect_turn_around()
	
	apply_gravity(delta)
	move_and_slide()

func move_character() -> void:
	velocity.x = direction * SPEED

func detect_turn_around() -> void:
	if not $RayCast2D.is_colliding() and is_on_floor():
		direction *= -1
		scale.x = -scale.x

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

func take_damage(damage_source_position: Vector2) -> void:
	if is_dead or is_hurt:
		return

	# Decrease health and check for death
	AudioManager.play_hurt()
	health -= 1
	if health <= 0:
		is_dead = true
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("Death")
		$Area2D/HurtBox.set_deferred("disabled", true)  # For CollisionShape2D
		$HitBox.set_deferred("disabled", true)  # For Area2D

	else:
		# Handle the hurt state
		is_hurt = true
		$AnimatedSprite2D.play("Hurt")
		velocity = Vector2.ZERO  # Stop movement during hurt animation

	# Calculate knockback direction
	var knockback_direction = sign(global_position.x - damage_source_position.x)
	velocity.x = knockback_direction * damage_knockback.x
	velocity.y = 0

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Hurt":
		is_hurt = false
		$AnimatedSprite2D.play("Walk")  # Play walk animation after hurt
	if $AnimatedSprite2D.animation == "Death":
		queue_free()  # Remove the enemy from the scene
