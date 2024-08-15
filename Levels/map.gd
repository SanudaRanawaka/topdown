extends Node2D
class_name Map
@onready var marker_2d = $Marker2D
var spawn_position
@onready var label = $Label
signal change_scene(scene_name)
var scene_changed = false
@export var destination: String


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_position = marker_2d.position
	label.set_visible(false)
	scene_changed = false

func _on_area_2d_become_highlighted(indicator):
	label.set_visible(indicator)

func _process(_delta):
	if scene_changed:
		if destination != null:
			emit_signal("change_scene",destination)
			print("scenesignalemitted")
	scene_changed = false

func _on_area_2d_become_interacted():
	scene_changed= true

func set_scene_changed(flag):
	scene_changed = flag
	
func set_destination(flag):
	destination = flag
