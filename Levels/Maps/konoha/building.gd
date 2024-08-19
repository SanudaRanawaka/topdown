extends Node2D
@onready var label = $Label
@export var connected_scene: String
var scene_folder = "res://Levels/Maps/konoha/"
# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_visible(false)

func _on_area_2d_become_highlighted(indicator):
	label.set_visible(indicator)

#call map and send destinations
func _on_area_2d_become_interacted(spawn_position):
	SceneManager.current_map = self.name
	SceneManager.change_scene(connected_scene,spawn_position)

#load destinations
func load_data():
	pass
