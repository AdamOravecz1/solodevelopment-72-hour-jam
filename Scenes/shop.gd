extends Area2D

var fire_rate = 1
var fire_range = 1
var health = 1
var max_speed = 1
var accelaration = 1

var upgraded = true
var level = -1

@onready var ship = get_tree().get_first_node_in_group("Ship")

func _ready() -> void:
	$CanvasLayer/ColorRect.modulate = Color(1, 1, 1, 0)  # Start fully transparent

func _on_body_entered(body: Node2D) -> void:
	$CanvasLayer.visible = true
	ship.can_fire = false
	ship.stop_fish()
	$Label.visible = true
	
	
func _on_body_exited(body: Node2D) -> void:
	$CanvasLayer.visible = false
	ship.can_fire = true
	ship.start_fish()
	$Label.visible = false
	if upgraded:
		level += 1
		upgraded = false
	if level == 1:
		for i in range(5):
			ship.fishes["fish"].append(2)
		for i in range(2):
			ship.fishes["shark"].append(4)
	if level == 2:
		for i in range(3):
			ship.fishes["fish"].append(2)
		ship.fishes["shark"].append(4)
		ship.fishes["wheal"].append(6)
	if level == 3:
		for i in range(6):
			ship.fishes["fish"].append(2)
		ship.fishes["tentacle"].append(4)
	if level == 4:
		for i in range(3):
			ship.fishes["shark"].append(4)
		for i in range(3):
			ship.fishes["wheal"].append(6)
	if level == 5:
		for i in range(4):
			ship.fishes["tentacle"].append(4)
	if level == 6:
		for i in range(3):
			ship.fishes["tentacle"].append(4)
		for i in range(3):
			ship.fishes["wheal"].append(6)
	if level == 7:
		ship.it_time = true
		for key in ship.fishes.keys():
			ship.fishes[key] = []
			

		


func _on_fire_rate_pressed() -> void:
	if fire_rate < 4 and ship.points >= fire_rate*5:
		$Buy.play()
		ship.update_points(-fire_rate*5)
		fire_rate += 1
		ship.shoot_cooldown -= 0.2
	if fire_rate != 4:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label.text = "lvl:" + str(fire_rate) + " cost:" + str(fire_rate*5)
	else:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label.text = "lvl:max"


func _on_fire_range_pressed() -> void:
	if fire_range < 4 and ship.points >= fire_range*5:
		$Buy.play()
		ship.update_points(-fire_range*5)
		fire_range += 1
		ship.harpoon_speed += 100
	if fire_range != 4:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label2.text = "lvl:" + str(fire_range) + " cost:" + str(fire_range*5)
	else:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label2.text = "lvl:max"


func _on_health_pressed() -> void:
	if health < 4 and ship.points >= health*5:
		$Buy.play()
		ship.update_points(-health*5)
		health += 1
		ship.increase_max_health(1)
	if health != 4:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label3.text = "lvl:" + str(health) + " cost:" + str(health*5)
	else:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label3.text = "lvl:max"


func _on_max_speed_pressed() -> void:
	if max_speed < 4 and ship.points >= max_speed*5:
		$Buy.play()

		ship.update_points(-max_speed*5)
		max_speed += 1
		ship.max_speed += 50
	if max_speed != 4:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label4.text = "lvl:" + str(max_speed) + " cost:" + str(max_speed*5)
	else:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label4.text = "lvl:max"


func _on_accelaration_pressed() -> void:
	if accelaration < 4 and ship.points >= accelaration*5:
		$Buy.play()

		ship.update_points(-accelaration*5)
		accelaration += 1
		ship.acceleration += 50
	if accelaration != 4:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label5.text = "lvl:" + str(accelaration) + " cost:" + str(accelaration*5)
	else:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label5.text = "lvl:max"


func _on_heal_pressed() -> void:
	if ship.points >= 5:
		$Buy.play()

		ship.update_points(-5)
		ship.take_damage(-ship.max_health) 


func _on_new_day_pressed() -> void:
	print("pressed")

	if not upgraded:
		var tween = create_tween()
		
		tween.tween_property($CanvasLayer/ColorRect, "modulate", Color(1, 1, 1, 1), 1.0)  # visible
		$Morning.play()
		tween.tween_property($CanvasLayer/ColorRect, "modulate", Color(1, 1, 1, 0), 1.0).set_delay(1.0)  # transparent
	upgraded = true



	
