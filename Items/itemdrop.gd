extends CharacterBody2D
@onready var sprite_2d = $Sprite2D

var item_name

func _ready():
	item_name = "Senzu Bean"

func _on_area_2d_become_highlighted(indicator):
	if indicator:
		sprite_2d.texture = load("res://Assets/item_icons/senzubeanH.png")
	else:
		sprite_2d.texture = load("res://Assets/item_icons/senzubean.png")

#func pickup():
	
