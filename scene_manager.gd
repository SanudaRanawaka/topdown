class_name SceneManager extends Node

var player:Player

var scene_dir_path = "res://Levels/"

func change_scene(from, scene_name: String)->void:
	player = from.player
	player.get_parent().remove_child(player)
	
	var full_path = scene_dir_path + scene_name + ".tscn"
	from.get_tree().call_deferred("change_scene_to_file",full_path)
