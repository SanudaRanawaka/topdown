extends Node2D
#@onready var sprite_2d = $Sprite2D
@onready var sprite_2d = $TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	if randi() % 7 ==0:
		sprite_2d.texture = load("res://Assets/item_icons/dragonball1.png")
	elif randi() %7 ==1:
		sprite_2d.texture = load("res://Assets/item_icons/dragonball2.png")
	elif randi() %7 ==2:
		sprite_2d.texture = load("res://Assets/item_icons/dragonball3.png")
	elif randi() %7 ==3:
		sprite_2d.texture = load("res://Assets/item_icons/dragonball4.png")
	elif randi() %7 ==4:
		sprite_2d.texture = load("res://Assets/item_icons/dragonball5.png")
	elif randi() %7 ==5:
		sprite_2d.texture = load("res://Assets/item_icons/dragonball6.png")
	else:
		sprite_2d.texture = load("res://Assets/item_icons/dragonball7.png")
