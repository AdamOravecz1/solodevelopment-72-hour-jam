extends Node2D

const harpoon_scene := preload("res://Scenes/harpoon.tscn")
const fish_scene := preload("res://Scenes/fish.tscn")
const warning_texture: Texture2D = preload("res://Sprites/Danger.png")

func create_harpoon(pos, dir):
	var harpoon = harpoon_scene.instantiate()
	$Projectiles.add_child(harpoon)
	harpoon.setup(pos, dir)

func create_fish(pos, dir):
	var fish = fish_scene.instantiate()
	var warning = Sprite2D.new()
	warning.texture = warning_texture
	warning.position = pos + Vector2(0, -20)
	$Warnings.add_child(warning)
	await get_tree().create_timer(2.0).timeout
	warning.queue_free()
	$Entity.add_child(fish)
	fish.setup(pos, dir)

	
