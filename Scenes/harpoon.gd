extends Area2D

var damage: int = 1

@export var gravity_force: float = 200.0  

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

var already_hit := []

func setup(pos: Vector2, dir: Vector2, speed):
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
	rotation = velocity.angle()

func _on_kill_timer_timeout():
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if "hit" in area and (area not in already_hit):
		if area.health >= 0 and area.intact:
			$AudioStreamPlayer.play()
		area.hit(damage, velocity)
	already_hit.append(area)
