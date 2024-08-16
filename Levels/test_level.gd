extends Node2D
class_name Game

@export var player : Player
@export var ui : UI
@export var map : Map

var current_scene_path
var current_scene_name

func _ready():
	#	call ui stuff
	if !player.update_health.is_connected(ui._on_update_health):
		player.update_health.connect(ui._on_update_health)
	if !player.start_dialogue.is_connected(ui._on_start_dialogue):
		player.start_dialogue.connect(ui._on_start_dialogue)
	# default scene
	current_scene_path = "res://Levels/konoha.tscn"
	current_scene_name = "konoha"
	#check if the map changing signal is connected
	if !map.change_scene.is_connected(self.on_change_scene):
		map.change_scene.connect(self.on_change_scene)

func on_change_scene(scene_array):
	print("on_change_scene")
	var scene_name = scene_array[0]
	var scene_data_name = scene_array[1]
	map.change_scene.disconnect(self.on_change_scene)
	get_node(current_scene_name).queue_free()
	current_scene_name = scene_data_name
	var current_map = load("res://Levels/"+scene_name+".tscn")
	var instance = current_map.instantiate()
	##watch out for if dialog is open and stuff like that
	add_child(instance)
	instance.name = scene_data_name
	player.position.x = scene_array[2][0]
	player.position.y = scene_array[2][1]
	current_scene_path = "res://Levels/"+scene_name+".tscn"
	var node = get_node(scene_data_name)
	#print("node and instance")
	#print(node)
	map = node
	print("map change")
	print(map)
	#print(instance)
	if !map.change_scene.is_connected(self.on_change_scene):
		map.change_scene.connect(self.on_change_scene)
