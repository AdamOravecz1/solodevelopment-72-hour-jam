extends Node2D

const harpoon_scene := preload("res://Scenes/harpoon.tscn")
const bullet_scene := preload("res://Scenes/bullet.tscn")
const fish_scene := preload("res://Scenes/fish.tscn")
const shark_scene := preload("res://Scenes/shark.tscn")
const wheal_scene := preload("res://Scenes/wheal.tscn")
const tentacle_scene := preload("res://Scenes/tentacle.tscn")
const it_scene := preload("res://Scenes/it.tscn")
const warning_texture: Texture2D = preload("res://Sprites/Danger.png")

func create_harpoon(pos, dir):
	var harpoon = harpoon_scene.instantiate()
	$Projectiles.add_child(harpoon)
	harpoon.setup(pos, dir)

func create_fish(pos, dir, health):
	var fish = fish_scene.instantiate()
	var warning = Sprite2D.new()
	warning.texture = warning_texture
	warning.position = pos + Vector2(0, -20)
	$Warnings.add_child(warning)
	await get_tree().create_timer(2.0).timeout
	warning.queue_free()
	$Entity.add_child(fish)
	fish.setup(pos, dir, health)

func create_shark(pos, dir, health):
	var shark = shark_scene.instantiate()
	var warning = Sprite2D.new()
	warning.texture = warning_texture
	warning.position = pos + Vector2(0, -20)
	$Warnings.add_child(warning)
	await get_tree().create_timer(2.0).timeout
	warning.queue_free()
	$Entity.add_child(shark)
	shark.setup(pos, dir, health)
	
func create_wheal(pos, dir, health):
	var wheal = wheal_scene.instantiate()
	var warning = Sprite2D.new()
	warning.texture = warning_texture
	warning.position = pos + Vector2(0, -20)
	$Warnings.add_child(warning)
	await get_tree().create_timer(2.0).timeout
	warning.queue_free()
	$Entity.add_child(wheal)
	wheal.setup(pos, dir, health)
	
func create_tentacle(pos, dir, health):
	var tentacle = tentacle_scene.instantiate()
	var warning = Sprite2D.new()
	warning.texture = warning_texture
	warning.position = pos + Vector2(0, -20)
	$Warnings.add_child(warning)
	await get_tree().create_timer(2.0).timeout
	warning.queue_free()
	$Entity.add_child(tentacle)
	tentacle.setup(pos, dir, health)
	
func create_bullets(pos, dir, speed):
	var bullet = bullet_scene.instantiate()
	$Entity.add_child(bullet)
	bullet.setup(pos, dir,speed)


var panning := false
var pan_time := 0.0
var pan_duration := 3.0       # seconds
var pan_speed := 50.0         # pixels per second

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("dash"):
		$Entity/Ship.can_move = false
		$Entity/Ship/Camera2D.enabled = false
		$BossCamera.position = Vector2($Entity/Ship.global_position.x, -53)
		$BossCamera.enabled = true

		# Start panning
		panning = true
		pan_time = 0.0

	# Handle smooth pan
	if panning:
		pan_time += delta
		if pan_time < pan_duration:
			$BossCamera.position.x += pan_speed * delta
		else:
			panning = false
			create_it()
			
	# Continuous shake
	if shaking:
		var offset = Vector2(
			randf_range(-shake_magnitude, shake_magnitude),
			randf_range(-shake_magnitude, shake_magnitude)
		)
		$BossCamera.position = original_position + offset
			
func create_it():
	var pos = $Entity/Ship.global_position + Vector2(256, 128)
	var it = it_scene.instantiate()
	$Entity.add_child(it)
	it.setup(pos)
	start_camera_shake()
	
var shaking := false
var shake_magnitude := 20.0
var original_position := Vector2.ZERO

func start_camera_shake(magnitude := 2.0) -> void:
	shake_magnitude = magnitude
	original_position = $BossCamera.position
	shaking = true

func stop_camera_shake() -> void:
	shaking = false
	$BossCamera.position = original_position
