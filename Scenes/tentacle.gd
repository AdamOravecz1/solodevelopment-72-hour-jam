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
		$CollisionShape2D.call_deferred("queue_free")
		health -= damage
		if health <= 0:
			queue_free()
			get_tree().get_first_node_in_group("Ship").update_points(8)
		$AnimatedSprite2D.play("attack")
		await get_tree().create_timer(0.5).timeout
		$CollisionShape2D2.set_deferred("disabled", false)

		


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
	else:
		get_tree().get_first_node_in_group("Ship").update_points(8)
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if "take_damage" in body:
		$AnimatedSprite2D.play("attack")

		var cs := get_node_or_null("CollisionShape2D")
		var cs2 := get_node_or_null("CollisionShape2D2")

		if cs:                       # only call methods if node exists
			cs.call_deferred("queue_free")
			
		if cs2:
			cs2.call_deferred("queue_free")

		body.take_damage(1)
