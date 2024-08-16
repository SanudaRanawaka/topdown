extends CharacterBody2D
@onready var sprite_2d = $Sprite2D

var item_name

func _ready():
	item_name = "Senzu Bean"
func _on_area_2d_become_highlighted(indicator):
	if indicator:
		sprite_2d.texture = load("res://Assets/item_icons/" + item_name + " H.png")
	else:
		sprite_2d.texture = load("res://Assets/item_icons/" + item_name + ".png")

func pickup():
	PlayerInventory.add_item(item_name, 1)
	get_parent().remove_from_state(self.name)
	queue_free()


func _on_area_2d_become_interacted():
	pickup()
