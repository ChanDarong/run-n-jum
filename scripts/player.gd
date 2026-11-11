extends CharacterBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const SPEED = 200.0 # 200 fram per second
const MAX_SPEED = 200
const ACCELERATION = 100

# Jump settings
const JUMP_HEIGHT: float = 56
const TIME_TO_PEAK: float = 0.28
const JUMP_VELOCITY: float = -(2 * JUMP_HEIGHT) / TIME_TO_PEAK
const JUMP_GRAVITY: float = (2 * JUMP_HEIGHT) / (TIME_TO_PEAK * TIME_TO_PEAK)
const FALL_GRAVITY: float = JUMP_GRAVITY * 1.5 

# Stuck dectection
var stuck_timer: float = 0
const STUCK_LIMIT: float = 1 # 1 second

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		var current_gravity = FALL_GRAVITY if velocity.y > 0 else JUMP_GRAVITY
		velocity.y += current_gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# velocity.x = move_toward(velocity.x, 0, SPEED)
	if (velocity.x < MAX_SPEED):
		velocity.x += ACCELERATION * delta
	else:
		velocity.x = SPEED
	
	move_and_slide()
	
	# Check if player is stuck on wall
	if is_on_wall() && !is_won:
		stuck_timer += delta
		if stuck_timer >= STUCK_LIMIT:
			print("You got stucked!")
			die()
	else:
		stuck_timer = 0 # Reset timer to 0 if you move freely again

var is_dead: bool = false
func die() -> void:
	if is_dead:
		return
	is_dead = true
	print('You die!')
	
	# TODO: Play dead sound
	collision_shape_2d.queue_free()
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()
	
var is_won: bool = false
func win() -> void:
	if is_won or is_dead:
		return
	else:
		is_won = true
		velocity = Vector2.ZERO # Stop player from moving
