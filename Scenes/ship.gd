extends CharacterBody2D

@export var max_speed: float = 50.0
@export var acceleration: float = 100.0
@export var friction: float = 100.0
@export var dash_speed: float = 200.0      # Extra speed during dash
@export var dash_duration: float = 0.1     # How long the dash lasts (seconds)
@export var dash_cooldown: float = 1.0     # Time before next dash

var dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0

var can_move := true
var can_fire := true

var dead := false

@export var shoot_cooldown: float = 0.6
var shoot_timer: float = 0.0
var harpoon_speed: float = 200.0

var points := 0

var fishes := {
	"fish": [2, 2, 2, 2],
	"shark": [],
	"wheal": [],
	"tentacle": []
}

@export var max_health := 3
var current_health := max_health

@onready var hearts := $CanvasLayer/HBoxContainer.get_children()

var it_time = false

func take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)
	update_hearts()
	$Damage.play()
	if current_health <= 0:
		die()

func update_hearts() -> void:
	for i in range(max_health):
		if i < current_health:
			hearts[i].texture = preload("res://Sprites/FullHeart.png")
		else:
			hearts[i].texture = preload("res://Sprites/EmptyHeart.png")

func update_visible_hearts() -> void:
	for i in range(len(hearts)):
		hearts[i].visible = i < max_health

func increase_max_health(amount: int) -> void:
	max_health += amount
	current_health = max_health
	update_visible_hearts()
	update_hearts()


func die() -> void:
	stop_fish()
	print("Player is dead!")
	can_move = false
	can_fire = false
	dead = true
	$CanvasLayer/Dead.visible = true
	$CanvasLayer/Again.visible = true
	

func _physics_process(delta: float) -> void:
	if dead and position.y <= 250:
		position.y += delta * 10
	if it_time and global_position.x >= 230:
		print("here")
		it_time = false
		get_parent().get_parent().here = true
	shoot_timer -= delta
	if Input.is_action_just_pressed("shoot") and shoot_timer <= 0.0 and can_fire:
		$Fire.pitch_scale = randf_range(0.8, 1.2)
		$Fire.play()
		shoot_timer = shoot_cooldown
		shoot_harpoon()
		
	var input_direction := Input.get_action_strength("right") - Input.get_action_strength("left")

	# Handle dash logic
	if Input.is_action_just_pressed("dash") and not dashing and dash_cooldown_timer <= 0.0 and input_direction != 0:
		$Dash.play()
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
		if input_direction != 0 and can_move:
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

	if can_move:
		move_and_slide()
	
func shoot_harpoon():
	var pos = global_position
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - pos).normalized()

	get_parent().get_parent().create_harpoon(pos, dir, harpoon_speed)


func _on_fish_timer_timeout() -> void:
	for fish in fishes["fish"]:
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
		get_parent().get_parent().create_fish(spawn_pos, jump_dir * speed, fish)

		# 5. Restart the timer with a random interval
		$FishTimer.start(randf_range(2.0, 3.0))
		
		fishes["fish"].erase(fish)
		
func _on_shark_timer_timeout() -> void:
	for fish in fishes["shark"]:
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
		get_parent().get_parent().create_shark(spawn_pos, jump_dir * speed, fish)

		# 5. Restart the timer with a random interval
		$SharkTimer.start(randf_range(2.0, 3.0))
		
		fishes["shark"].erase(fish)
		
func _on_wheal_timer_timeout() -> void:
	for fish in fishes["wheal"]:
		# 1. Pick a random point along the path under the boat
		$Path2D/PathFollow2D.progress_ratio = randf()
		var spawn_pos = $Path2D/PathFollow2D.global_position

		# 2. Base direction is straight up
		var base_dir = Vector2(0, -1)  # negative Y is up in Godot

		# 3. Add slight randomness (±10 degrees)
		var angle_offset = deg_to_rad(randf_range(-10, 10))
		var jump_dir = base_dir.rotated(angle_offset)

		# 4. Create the fish and launch it
		var speed = randf_range(600, 800)  # adjust for how fast it leaves the screen
		get_parent().get_parent().create_wheal(spawn_pos, jump_dir * speed, fish)

		# 5. Restart the timer with a random interval
		$WhealTimer.start(randf_range(2.0, 3.0))
		
		fishes["wheal"].erase(fish)

func _on_tentacle_timer_timeout() -> void:
	for fish in fishes["tentacle"]:
		# 1. Pick a random point along the path under the boat
		$Path2D/PathFollow2D.progress_ratio = randf()
		var spawn_pos = $Path2D/PathFollow2D.global_position

		var dir = 1 if spawn_pos >= global_position else -1
		get_parent().get_parent().create_tentacle(spawn_pos, dir, fish)

		# 5. Restart the timer with a random interval
		$TentacleTimer.start(randf_range(2.0, 3.0))
		
		fishes["tentacle"].erase(fish)
		
func update_points(point):
	points += point
	$CanvasLayer/Points.text = str(points)
		
func stop_fish():
	$FishTimer.stop()
	$SharkTimer.stop()
	$WhealTimer.stop()
	$TentacleTimer.stop()
	
func start_fish():
	$FishTimer.start()
	$SharkTimer.start()
	$WhealTimer.start()
	$TentacleTimer.start()


func _on_again_pressed() -> void:
	get_tree().reload_current_scene()
	
func victory():
	$CanvasLayer/Victory.visible = true
	$CanvasLayer/Again.visible = true
	
var day = 0
func add_day():
	day += 1
	$CanvasLayer/Day.text = "Day: " + str(day)

	
