extends Node

var player: Player
var current_map : String
var scene_dir_path = "res://Levels/"

var current_data

func _ready():
	current_map = "konoha"

# Called when the node enters the scene tree for the first time.
func change_scene(scene,spawn_position) -> void:
	#print(scene)
	player.get_tree().get_nodes_in_group("Map")[0].queue_free()
	var scene_node = load(scene_dir_path+scene+".tscn")
	#print(scene_dir_path+scene+".tscn")
	if scene != null:
		var sceneNode = scene_node.instantiate()
		sceneNode.name = current_map
		(player.get_tree().root).add_child(sceneNode)
		player.position = spawn_position
		print(current_map)
		
func load_data():
	var file_path = "res://Data/MapData/konohaData/"+self.name+"_save.json"
	var file_data  = FileAccess.open(file_path, FileAccess.READ)
	var json_data  = JSON.new()
	if file_data == null:
		print("read Failed")
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
