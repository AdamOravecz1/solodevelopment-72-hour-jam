extends Area2D

@export var gravity_force: float = 200.0  

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

var splashed = false

func setup(pos: Vector2, dir, speed):
	direction = dir.normalized()

	global_position = pos
	velocity = direction * speed


func _physics_process(delta: float) -> void:
	# Apply gravity for arc motion
	velocity.y += gravity_force * delta

	# Move based on velocity
	position += velocity * delta
	
	if position.y >= 0 and not splashed:
		splashed = true
		$SplashSound.pitch_scale = randf_range(0.5, 1.3)
		$SplashSound.play()


func hit(damage, dir):
	queue_free()


func _on_kill_timer_timeout() -> void:
	queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	if "take_damage" in body:
		body.take_damage(1)
		queue_free()
