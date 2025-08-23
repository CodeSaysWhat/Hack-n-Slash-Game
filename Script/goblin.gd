extends CharacterBody2D

const GRAVITY = 500.0
const SPEED = 50.0

# This variable will determine the direction of movement
var direction = 1

func _ready():
	$AnimatedSprite2D.play("Walk")

func _process(_delta):
	move_character()
	detect_turn_around()
	apply_gravity(_delta)

func move_character():
	# Move the character in the current direction
	velocity.x = direction * SPEED
	move_and_slide()

func detect_turn_around():
	# Check if the RayCast2D is colliding with something
	if not $RayCast2D.is_colliding() and is_on_floor():
		# Reverse the direction
		direction *= -1
		# Flip the sprite to face the new direction
		scale.x = -scale.x

func apply_gravity(delta):
	# Apply gravity to the vertical velocity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
