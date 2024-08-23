class_name Interactable extends Area2D
signal become_highlighted(indicator)
signal become_interacted(entrance_position)
# Called when the node enters the scene tree for the first time.
@export var entrance_position: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func call_highlight(indicator):
	emit_signal("become_highlighted", indicator)

func call_interact():
	emit_signal("become_interacted")
