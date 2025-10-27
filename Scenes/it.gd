extends Area2D

var health := 10

var speed := 30
var start = true

var up = true
var down = false

func setup(pos):
	position = pos
	$Rumble.play()

	
func _physics_process(delta: float) -> void:
	# --- Going up ---
	if up:
		if position.y > -75:
			position.y -= delta * speed
		else:
			up = false
			$Rumble.stop()
			$Music.play()
			$AnimatedSprite2D.play("default")
			get_parent().get_parent().stop_camera_shake()
			get_tree().get_first_node_in_group("Ship").can_move = true
			if start:
				$Attack1.start()
				start = false

	# --- Going down ---
	elif down:
		if position.y < 125:  # move back down until water level (y = 0)
			position.y += delta * speed
		else:
			$Rumble.stop()
			down = false  # stop moving once it’s back down
			get_parent().get_parent().stop_camera_shake()
			get_tree().get_first_node_in_group("Ship").victory()
			



func _on_attack_1_timeout() -> void:
	var num_bullets: int = 5
	var spread: float = 20.0         # degrees
	var speed: float = 200.0         # bullet speed
	var base_dir: Vector2 = Vector2.LEFT.rotated(deg_to_rad(60))

	# One shared random offset for the whole attack (±5°)
	var random_offset: float = randf_range(-5.0, 5.0)

	for i in range(num_bullets):
		var t: float = float(i) / float(num_bullets - 1)      # 0..1
		var angle_offset: float = lerp(-spread, spread, t) + random_offset
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
	var roll = randf() * 100.0
	print("Roll:", roll)

	if roll < 40.0:
		print("Attack1")
		$Attack1.start()
	elif roll < 80.0:
		print("Attack2")
		$Attack2.start()
	elif roll < 90.0:
		print("Attack3")
		$Attack3.start()
	else:
		print("Stagger")
		stagger()

		
func stagger():
	if get_tree().get_first_node_in_group("Ship").dead == false:
		$AnimatedSprite2D.visible = false
		$Stagger.start()
		var roll = randi_range(0, 2)
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
	if health > 0:
		stagger_off()
	if health <= 0:
		$Rumble.play()
		$Music.stop()
		down = true
		get_tree().get_first_node_in_group("Ship").fishes["tentacle"] = []
		get_parent().get_parent().rid_tentacle()
		get_parent().get_parent().start_camera_shake()

func _on_stagger_timeout() -> void:
	if health > 0:
		stagger_off()

func stagger_off():
	$CollisionShape2D.position = Vector2(-3, -1000)
	$It.visible = false
	$It2.visible = false
	$It3.visible = false
	$AnimatedSprite2D.visible = true
	execute_random_attack()

		
