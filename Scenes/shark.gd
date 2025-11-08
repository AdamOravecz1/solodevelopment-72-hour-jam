extends Area2D

var health: int = 3

@export var speed: float = 200.0
@export var gravity_force: float = 200.0  

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

var shoot := true
var was_above_water := false

func _ready() -> void:
	$ProgressBar.modulate = Color(1, 1, 1, 0)  # Start fully transparent
	$ProgressBar.set_as_top_level(true)

func setup(pos: Vector2, dir: Vector2, heal: int):
	health = heal
	
	global_position = pos
	direction = dir.normalized()

	# Initial velocity
	velocity = direction * speed

	# Initial rotation faces the throw direction
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	# Apply gravity for arc motion
	velocity.y += gravity_force * delta

	# Move based on velocity
	position += velocity * delta
	
	# Detect when shark crosses waterline (y = 0) going downward
	if position.y < 20:
		was_above_water = true  # shark is above water
	elif was_above_water and position.y >= 20 and velocity.y > 0 and shoot and health > 0:
		# Now it's going down and just re-entered the water
		shoot = false
		for i in range(3):
			# 1. Base direction is straight up
			var base_dir = Vector2(0, -1)

			# 2. Add slight randomness (±10 degrees)
			var angle_offset = deg_to_rad(randf_range(-10, 10))
			var jump_dir = base_dir.rotated(angle_offset)
			# 3. Random speed
			var speed = randf_range(200, 300)
			
			get_parent().get_parent().create_bullets(global_position, jump_dir, speed)

	# Rotate sprite to face current flight direction
	rotation = velocity.angle() + deg_to_rad(180)
	
	$ProgressBar.global_position = global_position + Vector2(0, -20)
	
func hit(damage, dir):
	health -= damage
	velocity += dir * 0.5
	if health <= 0:
		get_tree().get_first_node_in_group("Ship").check_fish()
		$CollisionShape2D.queue_free()
		get_tree().get_first_node_in_group("Ship").update_points(4)
		$Dead.play()
		visible = false
		$JumpTimer.stop()
		await get_tree().create_timer(1).timeout
		queue_free()
	flash_health()


func _on_jump_timer_timeout() -> void:
	get_tree().get_first_node_in_group("Ship").fishes["shark"].append(health)
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if "take_damage" in body:
		body.take_damage(1)
		
func flash_health():
	$ProgressBar.value = health
	var tween = create_tween()
	
	tween.tween_property($ProgressBar, "modulate", Color(1, 1, 1, 1), 1.0) 
	tween.tween_property($ProgressBar, "modulate", Color(1, 1, 1, 0), 1.0)
