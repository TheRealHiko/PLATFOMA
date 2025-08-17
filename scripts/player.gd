extends CharacterBody2D

# === Variables ===
var coyote = false
var jumping = false
var was_on_floor = false
var can_jump_from_floor = true
var health := 3
var max_health := 3
var invincible := false
var invincible_time := 1.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const SPEED = 120.0
const JUMP_VELOCITY = -300.0
const COYOTE_FRAMES = 60

# === Nodes ===
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var previous_floor_timer: Timer = $prevoiusfloor
@onready var jump_lockout_timer: Timer = $JumpLockout
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var health_bar: ProgressBar = $Camera2D/CanvasLayer/HealthBar
@onready var death_timer: Timer = $DeathTimer   # <-- Timer node in Player scene
@onready var collision: CollisionShape2D = $CollisionShape2D   # <-- reference to collision

# === Health and Damage ===
func take_damage(amount: int) -> void:
	if invincible:
		return
	
	health -= amount
	health_bar.value = health
	print("Player health:", health)

	if health <= 0:
		GlobalDeathSound.play()
		die()
	else:
		invincible = true
		invincible_timer.start(invincible_time)
		animated_sprite.modulate = Color(1, 0.5, 0.5)

func die() -> void:
	# Remove collision shape so player falls through everything
	if is_instance_valid(collision):
		collision.queue_free()

	# Slow down game time
	Engine.time_scale = 0.3

	# Add a little downward velocity to simulate falling
	velocity = Vector2.ZERO
	velocity.y = 100

	# Start timer (real time, unaffected by slow motion)
	death_timer.start(1.0)

func _on_death_timer_timeout() -> void:
	Engine.time_scale = 1.0  # Reset speed
	get_tree().reload_current_scene()

func _on_invincible_timer_timeout() -> void:
	invincible = false
	animated_sprite.modulate = Color(1, 1, 1)

# === Setup ===
func _ready() -> void:
	coyote_timer.wait_time = COYOTE_FRAMES / 60.0
	coyote_timer.one_shot = true

	previous_floor_timer.wait_time = COYOTE_FRAMES / 60.0
	previous_floor_timer.one_shot = true

	jump_lockout_timer.wait_time = 0.1
	jump_lockout_timer.one_shot = true

	health_bar.max_value = max_health
	health_bar.value = health

	death_timer.one_shot = true   # Make sure it's one-shot

# === Movement ===
func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		if was_on_floor and previous_floor_timer.is_stopped():
			previous_floor_timer.start()

	# Coyote jump
	if not is_on_floor() and not jumping and was_on_floor and not coyote:
		coyote = true
		coyote_timer.start()
		print("Coyote triggered")

	# Jump input
	if Input.is_action_just_pressed("jump"):
		if (is_on_floor() and can_jump_from_floor) or coyote:
			velocity.y = JUMP_VELOCITY
			jumping = true
			coyote = false
			was_on_floor = false
			can_jump_from_floor = false
			coyote_timer.stop()
			previous_floor_timer.stop()
			jump_lockout_timer.start()

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

	# Flip & animation
	animated_sprite.flip_h = direction < 0
	if is_on_floor():
		animated_sprite.play("Idle" if direction == 0 else "Move")
	else:
		animated_sprite.play("jump")

	move_and_slide()

# === Timers ===
func _on_coyote_timer_timeout() -> void:
	coyote = false
	print("Coyote expired")

func _on_prevoiusfloor_timeout() -> void:
	was_on_floor = false
	print("was_on_floor = false")

func _on_jump_lockout_timeout() -> void:
	can_jump_from_floor = true
	print("Jump lockout ended")
