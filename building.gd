extends Node2D
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_visible(false)

func _on_area_2d_become_highlighted(indicator):
	label.set_visible(indicator)


func _on_area_2d_become_interacted():
	get_parent().set_scene_changed(true)
