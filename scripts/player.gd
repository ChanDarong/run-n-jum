extends CharacterBody2D


const SPEED = 200.0
const MAX_SPEED = 200
const ACCELERATION = 100

# Jump settings
const JUMP_HEIGHT: float = 56
const TIME_TO_PEAK: float = 0.28
const JUMP_VELOCITY: float = -(2 * JUMP_HEIGHT) / TIME_TO_PEAK
const JUMP_GRAVITY: float = (2 * JUMP_HEIGHT) / (TIME_TO_PEAK * TIME_TO_PEAK)
const FALL_GRAVITY: float = JUMP_GRAVITY * 1.5 

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		var current_gravity = FALL_GRAVITY if velocity.y > 0 else JUMP_GRAVITY
		velocity.y += current_gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#velocity.x = move_toward(velocity.x, 0, SPEED)
	if (velocity.x < MAX_SPEED):
		velocity.x += ACCELERATION * delta
	else:
		velocity.x = SPEED
	
	move_and_slide()
