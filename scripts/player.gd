extends CharacterBody2D

# === Variables ===
var coyote = false
var jumping = false
var was_on_floor = false
var can_jump_from_floor = true  # NEW: Prevents "false floor" detection after jump

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const SPEED = 120.0
const JUMP_VELOCITY = -300.0
const COYOTE_FRAMES = 60

# === Nodes ===
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var previous_floor_timer: Timer = $prevoiusfloor
@onready var jump_lockout_timer: Timer = $JumpLockout  # NEW timer (add in scene)
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	coyote_timer.wait_time = COYOTE_FRAMES / 60.0
	coyote_timer.one_shot = true

	previous_floor_timer.wait_time = COYOTE_FRAMES / 60.0
	previous_floor_timer.one_shot = true

	jump_lockout_timer.wait_time = 0.1  # ~6 frames at 60fps
	jump_lockout_timer.one_shot = true

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

		# Trigger previous floor timer if we just left the floor
		if was_on_floor and previous_floor_timer.is_stopped():
			previous_floor_timer.start()

	# Trigger coyote
	if not is_on_floor() and not jumping and was_on_floor and not coyote:
		coyote = true
		coyote_timer.start()
		print("Coyote triggered")

	# Handle jump input
	if Input.is_action_just_pressed("jump"):
		if (is_on_floor() and can_jump_from_floor) or coyote:
			velocity.y = JUMP_VELOCITY
			jumping = true
			coyote = false
			was_on_floor = false
			can_jump_from_floor = false
			coyote_timer.stop()
			previous_floor_timer.stop()
			jump_lockout_timer.start()  # Temporarily ignore floor

	# Reset on landing
	if is_on_floor() and can_jump_from_floor:
		jumping = false
		coyote = false
		was_on_floor = true
		previous_floor_timer.stop()

	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flip and animation
	animated_sprite.flip_h = direction < 0
	if is_on_floor():
		animated_sprite.play("Idle" if direction == 0 else "Move")
	else:
		animated_sprite.play("jump")

	# Apply movement
	move_and_slide()


func _on_coyote_timer_timeout() -> void:
	coyote = false
	print("Coyote expired")

func _on_prevoiusfloor_timeout() -> void:
	was_on_floor = false
	print("was_on_floor = false")

func _on_jump_lockout_timeout() -> void:
	can_jump_from_floor = true
	print("Jump lockout ended")
