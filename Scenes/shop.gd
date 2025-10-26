extends Area2D

var fire_rate = 1
var fire_range = 1
var health = 1
var max_speed = 1
var accelaration = 1

@onready var ship = get_tree().get_first_node_in_group("Ship")


func _on_body_entered(body: Node2D) -> void:
	$CanvasLayer.visible = true
	ship.can_fire = false
	print("shop")
	



func _on_body_exited(body: Node2D) -> void:
	$CanvasLayer.visible = false
	ship.can_fire = true
	print("left")


func _on_fire_rate_pressed() -> void:
	if fire_rate < 3:
		fire_rate += 1
	if fire_rate != 3:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label.text = "lvl:" + str(fire_rate) + " cost:" + str(fire_rate)
	else:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label.text = "lvl:max"


func _on_fire_range_pressed() -> void:
	if fire_range < 3:
		fire_range += 1
	if fire_range != 3:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label2.text = "lvl:" + str(fire_range) + " cost:" + str(fire_range)
	else:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label2.text = "lvl:max"


func _on_health_pressed() -> void:
	if health < 3:
		health += 1
	if health != 3:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label3.text = "lvl:" + str(health) + " cost:" + str(health)
	else:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label3.text = "lvl:max"


func _on_max_speed_pressed() -> void:
	if max_speed < 3:
		max_speed += 1
	if max_speed != 3:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label4.text = "lvl:" + str(max_speed) + " cost:" + str(max_speed)
	else:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label4.text = "lvl:max"


func _on_accelaration_pressed() -> void:
	if accelaration < 3:
		accelaration += 1
	if accelaration != 3:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label5.text = "lvl:" + str(accelaration) + " cost:" + str(accelaration)
	else:
		$CanvasLayer/NinePatchRect/VBoxContainer2/Label5.text = "lvl:max"
