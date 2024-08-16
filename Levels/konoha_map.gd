extends Node2D
class_name Map
@onready var label = $Label
signal change_scene(scene_pair)
var scene_changed = false
@export var destination: Array
var current_data = null
var number = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_visible(false)
	scene_changed = false
	#load the konha item and npc spawn data
	current_data = load_data()
	#print("load data ready")
	#print(current_data)
	load_state(current_data)

func _on_area_2d_become_highlighted(indicator):
	label.set_visible(indicator)

func _process(_delta):
	if scene_changed:
		if destination != null:
			save_state(current_data)
			#call manager to change scenes
			emit_signal("change_scene",destination)
	scene_changed = false

func _on_area_2d_become_interacted():
	scene_changed= true

func set_scene_changed(flag):
	scene_changed = flag
	
func set_destination(flag):
	destination = flag
	
func load_data():
	print("self name is " + self.name)
	var file_path = "res://Data/MapData/konohaData/"+self.name+"_save.json"
	print(file_path)
	var file_data  = FileAccess.open(file_path, FileAccess.READ)
	var json_data  = JSON.new()
	if file_data == null:
		print("read Failed")
		print(json_data)
		return{}
	json_data.parse(file_data.get_as_text())
	file_data.close()
	file_data = null
	return json_data.get_data() 
	
func load_state(data):
	#print(data.size())
	var current_spawn
	for key in data:
		if data[key]["Spawn"]:
			current_spawn = load(data[key]["Path"])
			var instance = current_spawn.instantiate()
			add_child(instance)
			var x = data[key]["Position"][0]
			var y = data[key]["Position"][1]
			instance.position.x = x
			instance.position.y = y
			instance.name = key
		#print("load_state")
	#for key in current_data:
		#print(current_data[key]["Spawn"])

func remove_from_state(object_name):
	current_data[object_name]["Spawn"] = false
	#print("remove_from_state")
	#for key in current_data:
		#print(current_data[key]["Spawn"])
	save_state(current_data)

func save_state(save_data):
	var file_path = "res://Data/MapData/konohaData/"+self.name+"_save.json"
	print(file_path)
	var file_data  = FileAccess.open(file_path, FileAccess.WRITE)
	if file_data == null:
		print("read Failed")
		return{}
	var json_string = JSON.stringify(save_data)
	file_data.store_string(json_string)
	file_data.close()
	#print("save_state")
	#print(json_string)
	file_data = null
	
	
