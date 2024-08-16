extends Node2D
@onready var label = $Label
var file_data = null
var d = null
# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_visible(false)
	file_data = load_data()
	d = file_data["Destination"]

func _on_area_2d_become_highlighted(indicator):
	label.set_visible(indicator)

#call map and send destinations
func _on_area_2d_become_interacted():
	get_parent().set_scene_changed(true)
	get_parent().set_destination(d)

#load destinations
func load_data():
	var file_path = "res://Data/MapData/"+get_parent().name+"Data/"+self.name+".json"
	var file_data  = FileAccess.open(file_path, FileAccess.READ)
	var json_data  = JSON.new()
	if file_data != null:
		json_data.parse(file_data.get_as_text())
		file_data.close()
		file_data = null
		return json_data.get_data() 
