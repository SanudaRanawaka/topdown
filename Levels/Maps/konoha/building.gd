extends Node2D
@onready var label = $Label
@export var connected_scene: String
@export var spawn_position: Vector2
var scene_folder = "res://Levels/Maps/konoha/"
var data_path = "res://Data/MapData/konohaData/"+self.name+"_save.json"

signal door_interact(area_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_visible(false)

func _on_area_2d_become_highlighted(indicator):
	label.set_visible(indicator)

#call map and send destinations
func _on_area_2d_become_interacted():
	var map = get_parent()
	if map.is_in_group("Map"):
		SceneManager.change_scene(self.name)
	#SceneManager.current_map = self.name
	#data_path = "res://Data/MapData/konohaData/" + self.name + "_save.json"
	#SceneManager.load_data(data_path)
	#SceneManager.change_scene(connected_scene,spawn_position)
