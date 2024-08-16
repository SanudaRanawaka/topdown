extends Node2D
class_name Map
@onready var label = $Label

var current_data = null

@export var connected_scene: String
@export var from_scene: String
var scene_folder = "res://Levels/"

# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_visible(false)
	SceneManager.current_map = self.name

func _on_area_2d_become_highlighted(indicator):
	label.set_visible(indicator)

func _on_area_2d_become_interacted(spawn_position):
	SceneManager.call_deferred("change_scene",connected_scene,spawn_position)

	

	
	
