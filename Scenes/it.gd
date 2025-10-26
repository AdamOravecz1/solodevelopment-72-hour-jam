extends Area2D

var health := 10

var speed := 30
var start = true

func setup(pos):

	position = pos
	
func _physics_process(delta: float) -> void:
	if position.y >= -75:
		position.y -= delta * speed
	else:
		$AnimatedSprite2D.play("default")
		get_parent().get_parent().stop_camera_shake()
		get_tree().get_first_node_in_group("Ship").can_move = true
		if start:
			$Attack1.start()
			start = false


func _on_attack_1_timeout() -> void:
	var num_bullets: int = 5
	var spread: float = 20.0         # degrees
	var speed: float = 200.0         # bullet speed
	var base_dir: Vector2 = Vector2.LEFT.rotated(deg_to_rad(60))

	for i in range(num_bullets):
		var t: float = float(i) / float(num_bullets - 1)      # 0..1
		var angle_offset: float = lerp(-spread, spread, t)    # spread from -20° to +20°
		var dir: Vector2 = base_dir.rotated(deg_to_rad(angle_offset))
		get_parent().get_parent().create_bullets($Hand.global_position, dir, speed)
		
	execute_random_attack()
		

func _on_attack_2_timeout() -> void:
	var speed: float = 150.0
	var num_bullets: int = 7
	var base_dir: Vector2 = Vector2.UP

	for i in range(num_bullets):
		var angle_offset: float = randf_range(-20.0, 20.0) 
		var dir: Vector2 = base_dir.rotated(deg_to_rad(angle_offset)) 
		get_parent().get_parent().create_bullets($Hand.global_position, dir, speed)

		await get_tree().create_timer(0.1).timeout
		
	execute_random_attack()


func _on_attack_3_timeout() -> void:
	get_tree().get_first_node_in_group("Ship").fishes["tentacle"].append(2)
	execute_random_attack()
	
func execute_random_attack() -> void:
	var roll = randf() * 100.0  # 0–100 random value
	
	if roll < 40.0:
		$Attack1.start()
	elif roll < 80.0:
		$Attack2.start()
	elif roll < 90.0:
		$Attack3.start()
	else:
		stagger()
		
func stagger():
	$AnimatedSprite2D.visible = false
	var roll = randi_range(0, 2)
	print(roll)
	if roll == 0:
		$It.visible = true
		$CollisionShape2D.position = Vector2(-3, 14)
	elif roll == 1:
		$It2.visible = true
		$CollisionShape2D.position = Vector2(-8, 89)
	else:
		$It3.visible = true
		$CollisionShape2D.position = Vector2(-5, 58)
		

func hit(damage, dir):
	health -= damage
	stagger_off()
	if health <= 0:
		queue_free()

func _on_stagger_timeout() -> void:
	stagger_off()

func stagger_off():
	$CollisionShape2D.position = Vector2(-3, -1000)
	$It.visible = false
	$It2.visible = false
	$It3.visible = false
	$AnimatedSprite2D.visible = true
	execute_random_attack()
