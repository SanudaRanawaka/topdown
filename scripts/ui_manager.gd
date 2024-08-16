extends Node2D
class_name Game

@export var player : Player
@export var ui : UI

func _ready():
	#	call ui stuff
	if !player.update_health.is_connected(ui._on_update_health):
		player.update_health.connect(ui._on_update_health)
	if !player.start_dialogue.is_connected(ui._on_start_dialogue):
		player.start_dialogue.connect(ui._on_start_dialogue)
	# default scene
