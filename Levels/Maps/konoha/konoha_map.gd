extends Node2D
class_name Map
@onready var label = $Label

var current_data = null

@export var connected_scene: String
@export var from_scene: String
var scene_folder = "res://Levels/Maps/konoha/"
var data_path = "res://Data/MapData/konohaData/" + self.name + "_save.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_visible(false)
	

func _on_area_2d_become_highlighted(indicator):
	label.set_visible(indicator)

func _on_area_2d_become_interacted(spawn_position):
	data_path = "res://Data/MapData/konohaData/" + self.name + "_save.json"
	print("scene manager load "+self.name)
	SceneManager.load_data(connected_scene)
	SceneManager.call_deferred("change_scene",connected_scene,spawn_position)

	

	
	
