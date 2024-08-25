extends Node2D
class_name Map
@onready var label = $Label

var current_data = null

@export var connected_scene: String
@export var spawn_position: Vector2
var scene_folder = "res://Levels/Maps/konoha/"
var data_path = "res://Data/MapData/konohaData/" + self.name + "_save.json"

var file_data: Dictionary
var next_scene: String
# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_visible(false)
	print("\nMAP READY FUNCTION\n")
	print("map name is "+name)
	if name != null:
		file_data = SceneManager.load_data(name)
	
	

func _on_area_2d_become_highlighted(indicator):
	label.set_visible(indicator)

func _on_area_2d_become_interacted():
	data_path = "res://Data/MapData/konohaData/" + self.name + "_save.json"
	print("scene manager load "+self.name)
	SceneManager.call_deferred("change_scene",file_data["Exits"][0][0])
	
func change_name(aname):
	self.name = aname
	print(aname +" "+self.name)
