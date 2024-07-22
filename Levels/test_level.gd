extends Node2D
class_name Game

@export var player : Player
@export var ui : UI

func _ready():
	if !player.update_health.is_connected(ui._on_update_health):
		player.update_health.connect(ui._on_update_health)
