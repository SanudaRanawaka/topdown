extends Node

var player: Player
var current_map : String

var scene_dir_path = "res://Levels/"

# Called when the node enters the scene tree for the first time.
func change_scene(scene,position) -> void:
	print("change_scene")
	player.get_tree().get_nodes_in_group("Map")[0].queue_free()
	var scene_node = load(scene_dir_path+scene+".tscn")
	if scene != null:
		var sceneNode = scene_node.instantiate()
		(player.get_tree().root).add_child(sceneNode)
		player.position = position
