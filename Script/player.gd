extends CharacterBody2D
class_name Player

const SPEED = 250.0
const JUMP_VELOCITY = -250.0
const MAX_JUMPS = 2

var is_attacking = false
var is_hurt = false
var is_dead = false
var is_auto_running = false
var is_switched = false
var is_healing = false

var jump_count = 0

var hearts_list: Array[TextureRect] = []
var health: int = 5

var shader_material: ShaderMaterial

var pulse_timer = 0.0

@export var damage_knockback: Vector2 = Vector2(100, 0)
@onready var attack_hitbox = $AttackHitbox
@onready var hearts = $"."
@onready var screen_effect = $"../GameUI/ColorRect"
@onready var heal_timer := $HealTimer

var heal_hold_time := 0.0
const HEAL_DURATION := 3.0

func _ready() -> void:
	if screen_effect and screen_effect.material:
		screen_effect.visible = false
		screen_effect.material.set_shader_parameter("switch_color", false)
	
	$AttackHitbox.connect("body_entered", Callable(self, "_on_attack_hitbox_body_entered"))
	$AttackHitbox.monitoring = false
	shader_material = $AnimatedSprite2D.material as ShaderMaterial
	var hearts_parent = get_node("../GameUI/HBoxContainer")
	if hearts_parent:
		for child in hearts_parent.get_children():
			if child is TextureRect:
				hearts_list.append(child)
		print(hearts_list)

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and $AttackHitbox.monitoring == true and body.has_method("take_damage"):
		body.take_damage(global_position)

func take_damage(damage_source_position: Vector2) -> void:
	if is_dead or is_hurt:
		is_attacking = false
		return

	if health > 0:
		health -= 1
		AudioManager.play_hurt()
		update_heart_display()

		if health == 0:
			is_dead = true
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("Death")
			return

		is_attacking = false
		is_hurt = true
		$AnimatedSprite2D.play("Hurt")

		var knockback_direction = sign(global_position.x - damage_source_position.x)
		velocity.x = knockback_direction * damage_knockback.x
		velocity.y = 0

func update_heart_display() -> void:
	# Update heart display based on health
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health

		var anim_sprite = hearts_list[i].get_child(0) as AnimatedSprite2D
		if anim_sprite:
			if is_switched:
				if anim_sprite.animation != "Beating":
					anim_sprite.play("Beating")
			else:
				if anim_sprite.animation != "Idle":
					anim_sprite.play("Idle")

	# Enable edge effect only when health == 1
	if screen_effect and screen_effect.material:
		screen_effect.visible = (health == 1)

func start_auto_run():
	$AnimatedSprite2D.play("Run")
	is_auto_running = true

func _input(event):
	update_heart_display()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and is_on_floor() and not is_hurt:
		if not is_switched:
			if health >= 2:
				is_switched = true
				health -= 1
				update_heart_display()
				shader_material.set_shader_parameter("switch_color", is_switched)
		else:
			is_switched = false
			shader_material.set_shader_parameter("switch_color", is_switched)

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_attacking and not is_hurt and not is_dead and is_on_floor() and is_switched:
			is_attacking = true
			$AttackHitbox.monitoring = true
			AudioManager.play_slash()
			$AnimatedSprite2D.play("Attack")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"Hurt":
			is_hurt = false
		"Attack":
			is_attacking = false
			$AttackHitbox.monitoring = false
		"Death":
			await get_tree().create_timer(0.5).timeout
			is_switched = false
			shader_material.set_shader_parameter("switch_color", false)
			await get_tree().create_timer(0.1).timeout
			get_tree().reload_current_scene()

func _on_animated_sprite_2d_2_animation_finished() -> void:
	match $AnimatedSprite2D2.animation:
		"Heal":
			is_healing = false

func _on_attack_hitbox_enemy_hit(enemy: Node) -> void:
	if enemy.is_in_group("Enemy") and enemy.has_method("take_damage"):
		emit_signal("enemy_hit", enemy)

func _physics_process(delta: float) -> void:
	if is_auto_running:
		velocity.x = SPEED
		move_and_slide()
		return

	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if is_hurt:
		move_and_slide()
		return
	
	if is_healing:
		velocity = Vector2.ZERO
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_count = 0

	# Handle Healing when holding the "Heal" key
	if Input.is_action_pressed("Heal") and is_on_floor() and not is_switched:
		if health < hearts_list.size() and not is_dead:
			if not is_healing:  # Start healing animation and process
				$AnimatedSprite2D.play("Heal")
				is_healing = true
			heal_hold_time += delta
			if heal_hold_time >= HEAL_DURATION:
				health += 1
				update_heart_display()
				heal_hold_time = 0.0  # Reset the timer after healing
				AudioManager.play_healed()
				$AnimatedSprite2D2.play("Done")  # Optional animation for healing completion
				is_healing = false  # Stop the healing process

	if Input.is_action_just_released("Heal"):
		heal_hold_time = 0.0  # Reset the timer when key is released
		if is_healing:  # Stop healing if the key is released
			is_healing = false
			$AnimatedSprite2D.stop()  # Stop the healing animation

	if Input.is_action_just_pressed("Double Jump") and jump_count < MAX_JUMPS and not is_switched:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_healing and is_on_floor():
		if velocity.x == 0:
			$AnimatedSprite2D.play("Idle")
		else:
			$AnimatedSprite2D.play("Run")
	else:
		if not is_on_floor():
			if jump_count <= 1 and $AnimatedSprite2D.animation != "Jump":
				AudioManager.play_jump()
				$AnimatedSprite2D.play("Jump")
			elif jump_count == 2 and $AnimatedSprite2D.animation != "Double Jump":
				AudioManager.play_jump()
				$AnimatedSprite2D.play("Double Jump")

	if direction < 0:
		$AnimatedSprite2D.flip_h = true
		$AttackHitbox.scale.x = -abs($AttackHitbox.scale.x)
	elif direction > 0:
		$AnimatedSprite2D.flip_h = false
		$AttackHitbox.scale.x = abs($AttackHitbox.scale.x)
	
	move_and_slide()
