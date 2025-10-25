extends CharacterBody2D

@export var max_speed: float = 100.0
@export var acceleration: float = 200.0
@export var friction: float = 100.0
@export var dash_speed: float = 200.0      # Extra speed during dash
@export var dash_duration: float = 0.1     # How long the dash lasts (seconds)
@export var dash_cooldown: float = 1.0     # Time before next dash

var dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0

@export var shoot_cooldown: float = 0.3
var shoot_timer: float = 0.0

func _physics_process(delta: float) -> void:
	shoot_timer -= delta
	if Input.is_action_just_pressed("shoot") and shoot_timer <= 0.0:
		shoot_timer = shoot_cooldown
		shoot_harpoon()
		
	var input_direction := Input.get_action_strength("right") - Input.get_action_strength("left")

	# Handle dash logic
	if Input.is_action_just_pressed("dash") and not dashing and dash_cooldown_timer <= 0.0 and input_direction != 0:
		dashing = true
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown
		velocity.x = input_direction * dash_speed

	if dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			dashing = false
	else:
		# Apply movement normally only if not dashing
		if input_direction != 0:
			velocity.x = move_toward(velocity.x, input_direction * max_speed, acceleration * delta)
			$AnimatedSprite2D.play("sail")
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)
			$AnimatedSprite2D.play("default")

	# Flip sprite depending on direction
	if input_direction == 1:
		$AnimatedSprite2D.flip_h = false
	elif input_direction == -1:
		$AnimatedSprite2D.flip_h = true

	# Update dash cooldown timer
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta

	move_and_slide()
	
func shoot_harpoon():
	var pos = global_position
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - pos).normalized()

	get_parent().get_parent().create_harpoon(pos, dir)


func _on_fish_timer_timeout() -> void:
	# 1. Pick a random point along the path under the boat
	$Path2D/PathFollow2D.progress_ratio = randf()
	var spawn_pos = $Path2D/PathFollow2D.global_position

	# 2. Base direction is straight up
	var base_dir = Vector2(0, -1)  # negative Y is up in Godot

	# 3. Add slight randomness (±10 degrees)
	var angle_offset = deg_to_rad(randf_range(-10, 10))
	var jump_dir = base_dir.rotated(angle_offset)

	# 4. Create the fish and launch it
	var speed = randf_range(400, 600)  # adjust for how fast it leaves the screen
	get_parent().get_parent().create_fish(spawn_pos, jump_dir * speed)

	# 5. Restart the timer with a random interval
	$FishTimer.start(randf_range(2.0, 3.0))


	
