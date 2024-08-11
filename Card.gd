extends Node2D
@onready var card_name = "example"
@onready var card_number = 0

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.add_card(0)
		queue_free()
