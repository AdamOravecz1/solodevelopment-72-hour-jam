extends Area2D

@export var speed: float = 200.0
@export var gravity_force: float = 200.0  

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func setup(pos: Vector2, dir: Vector2):
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
