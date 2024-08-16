extends Node2D
@onready var label = $Label
@export var connected_scene: String
var scene_folder = "res://Levels/"
# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_visible(false)

func _on_area_2d_become_highlighted(indicator):
	label.set_visible(indicator)

#call map and send destinations
func _on_area_2d_become_interacted(position):
	SceneManager.change_scene(connected_scene,position)

#load destinations
func load_data():
	pass
