extends Node2D
class_name Game

@export var player : Player
@export var ui : UI
@export var map : Map

var current_scene_path
var current_scene_name

func _ready():
	if !player.update_health.is_connected(ui._on_update_health):
		player.update_health.connect(ui._on_update_health)
	if !player.start_dialogue.is_connected(ui._on_start_dialogue):
		player.start_dialogue.connect(ui._on_start_dialogue)
	current_scene_path = "res://Levels/konoha_revamp.tscn"
	current_scene_name = "konoha"
	if !map.change_scene.is_connected(self.on_change_scene):
		map.change_scene.connect(self.on_change_scene)
	print(map)

func on_change_scene(scene_name):
	map.change_scene.disconnect(self.on_change_scene)
	get_node(current_scene_name).queue_free()
	current_scene_name = scene_name
	var current_map = load("res://Levels/"+scene_name+".tscn")
	var instance = current_map.instantiate()
	##watch out for if dialog is open and stuff like that
	add_child(instance)
	instance.name = scene_name
	player.position = instance.spawn_position
	current_scene_path = "res://Levels/"+scene_name+".tscn"
	var node = get_node(scene_name)
	print(node)
	map = node
	if !map.change_scene.is_connected(self.on_change_scene):
		map.change_scene.connect(self.on_change_scene)
		print("reconnect" + map.name)
