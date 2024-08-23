extends Node

var player: Player
var current_map : String
var scene_dir_path = "res://Levels/Maps/konoha/"

var current_data
#---MY NEW SHIT---#
var current_spawn_point
var map_start_path = "res://Data/MapData/konohaData/"
var current_data_file : Dictionary

func _ready():
	current_data_file = load_data("konoha")
	print("scene manager autoload ready")
	var current_spawn_point = [0,0]
	
func change_scene(file_name)-> void:
	var has_exits = false
	var map_index = -1
	print("START OF CHANGE SCENE")
	print("\n\nbuilding that loads is "+file_name+"\n\n")
	for i in range(current_data_file["Exits"].size()):
		if current_data_file["Exits"][i][0] == file_name:
			has_exits = true
			map_index = i
	if has_exits:
		print("Change Scene Successful")
		current_spawn_point = [current_data_file["Exits"][map_index][1],current_data_file["Exits"][map_index][2]]
		current_data_file = load_data(file_name)
		if current_data_file != null:
			player.get_tree().get_nodes_in_group("Map")[0].queue_free()
			load_scene(file_name,current_data_file)
		else:
			print("ERROR DDATA FILE NULL")
	else:
		print("Change Scene Unsuccessful")
		print("Doors does not have "+ file_name)
	

func load_data(file_name):
	print("load data file name is " + file_name)
	if file_name == null:
		print("read Failed")
		return
	var file_path = map_start_path + file_name + "_data.json"
	var file_data  = FileAccess.open(file_path, FileAccess.READ)
	if file_data == null:
		return {"bruh":"bruh"}
	var json_data  = JSON.new()
	json_data.parse(file_data.get_as_text())
	file_data.close()
	file_data = null
	return json_data.get_data() 

func load_scene(build_name, file_data):
	print("load scene file name is " + build_name)
	if file_data != null:
		var scene_node = load(scene_dir_path + file_data["SceneName"]+ ".tscn")
		var sceneNode = scene_node.instantiate()
		sceneNode.name = build_name
		sceneNode.change_name(build_name)
		player.position = Vector2(current_spawn_point[0],current_spawn_point[1])
		print(build_name)
		print("build_name "+sceneNode.name)
		(player.get_tree().root).add_child(sceneNode)








#func _ready():
	#current_map = "konoha"
	#load_data("res://Data/MapData/konohaData/konoha_save.json")
#
## Called when the node enters the scene tree for the first time.
#func change_scene(scene,spawn_position) -> void:
	#print("The Scene Is ")
	#print(scene)
	#player.get_tree().get_nodes_in_group("Map")[0].queue_free()
	#var scene_node = load(scene_dir_path+scene+".tscn")
	##print(scene_dir_path+scene+".tscn")
	#if scene != null:
		#var sceneNode = scene_node.instantiate()
		#sceneNode.name = current_map
		#(player.get_tree().root).add_child(sceneNode)
		#player.position = spawn_position
		#print(current_map)
		#
		#
#
#func load_data(file_path):
	#if file_path == null:
		#print("read Failed")
		#return
	#print(file_path)
	#var file_data  = FileAccess.open(file_path, FileAccess.READ)
	#if file_data == null:
		#return
	#var json_data  = JSON.new()
	#json_data.parse(file_data.get_as_text())
	#file_data.close()
	#file_data = null
	#print(json_data.get_data())
	#return json_data.get_data() 
	#
#func load_state(data):
	##print(data.size())
	#var current_spawn
	#for key in data:
		#if data[key]["Spawn"]:
			#current_spawn = load(data[key]["Path"])
			#var instance = current_spawn.instantiate()
			#add_child(instance)
			#var x = data[key]["Position"][0]
			#var y = data[key]["Position"][1]
			#instance.position.x = x
			#instance.position.y = y
			#instance.name = key
		##print("load_state")
	##for key in current_data:
		##print(current_data[key]["Spawn"])
#
#func remove_from_state(object_name):
	#current_data[object_name]["Spawn"] = false
	##print("remove_from_state")
	##for key in current_data:
		##print(current_data[key]["Spawn"])
	#save_state(current_data)
#
#func save_state(save_data):
	#var file_path = "res://Data/MapData/konohaData/"+self.name+"_save.json"
	#var file_data  = FileAccess.open(file_path, FileAccess.WRITE)
	#if file_data == null:
		#print("read Failed")
		#return{}
	#var json_string = JSON.stringify(save_data)
	#file_data.store_string(json_string)
	#file_data.close()
	##print("save_state")
	##print(json_string)
	#file_data = null
