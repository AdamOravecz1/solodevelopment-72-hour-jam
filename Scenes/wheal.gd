extends Area2D

var health: int = 6

@export var speed: float = 200.0
@export var gravity_force: float = 200.0  

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

var intact := true

func _ready() -> void:
	$ProgressBar.modulate = Color(1, 1, 1, 0)  # Start fully transparent
	$ProgressBar.set_as_top_level(true)
	$ProgressBar.visible = get_tree().get_first_node_in_group("Pause").health_bar

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

	# Rotate sprite to face current flight direction
	rotation = velocity.angle() + deg_to_rad(180)
	$ProgressBar.global_position = global_position + Vector2(0, -20)
	
func hit(damage, dir):
	health -= damage
	velocity += dir * 0.2
	if health <= 0:
		get_tree().get_first_node_in_group("Ship").check_fish()
		$CollisionShape2D.queue_free()
		get_tree().get_first_node_in_group("Ship").update_points(6)
		$Dead.play()
		visible = false
		$JumpTimer.stop()
		$ShootTimer.stop()
		await get_tree().create_timer(1).timeout
		queue_free()
	flash_health()


func _on_jump_timer_timeout() -> void:
	get_tree().get_first_node_in_group("Ship").fishes["wheal"].append(health)

	queue_free()


func _on_shoot_timer_timeout() -> void:
	if position.y <= 0:
		# Shoot in the direction the whale is facing, rotated 90° if sprite faces up
		var shoot_dir = Vector2.UP.rotated(rotation)  # changed from RIGHT to UP
		var speed = 150
		get_parent().get_parent().create_bullets(global_position, shoot_dir, speed)

func _on_body_entered(body: Node2D) -> void:
	if "take_damage" in body:
		body.take_damage(1)
		
func flash_health():
	$ProgressBar.value = health
	var tween = create_tween()
	
	tween.tween_property($ProgressBar, "modulate", Color(1, 1, 1, 1), 1.0) 
	tween.tween_property($ProgressBar, "modulate", Color(1, 1, 1, 0), 1.0)
