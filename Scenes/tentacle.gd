extends Area2D

var health := 4

var speed := 20
var side := 0


func setup(pos, dir, heal):
	if dir == -1:
		side = dir
		$AnimatedSprite2D.flip_h = true
		$CollisionShape2D.position.x = -20
	health = heal
	position = pos
	
func _physics_process(delta: float) -> void:
	if position.y >= 0:
		position.y -= delta * speed

func hit(damage, velocity):
	if position.y <= 0:
		health -= damage
		if health <= 0:
			queue_free()
			get_tree().get_first_node_in_group("Ship").update_points(8)
		$CollisionShape2D.queue_free()
		$AnimatedSprite2D.play("attack")
		


func _on_animated_sprite_2d_animation_finished() -> void:
	var speed = 200           # bullet speed
	var spread = 20           # half-angle of the spread
	var num_bullets = 5
	var tilt_up_deg = 50      # tilt relative to the base direction

	# Flip directions: right now shoots left, left now shoots right
	var base_dir = Vector2.LEFT if side != -1 else Vector2.RIGHT

	# Adjust tilt so it's always "up" relative to the shooting side
	var tilt = tilt_up_deg if side != -1 else -tilt_up_deg

	# Shoot bullets in a symmetric spread, angled relative to base_dir
	for i in range(num_bullets):
		var t = float(i) / float(num_bullets - 1)  # 0..1
		var angle_offset = lerp(-spread, spread, t) + tilt
		var dir = base_dir.rotated(deg_to_rad(angle_offset))
		get_parent().get_parent().create_bullets(global_position, dir, speed)

	if health > 1:
		get_tree().get_first_node_in_group("Ship").fishes["tentacle"].append(health)
	queue_free()
	
