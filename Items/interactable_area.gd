extends Area2D
signal become_highlighted(indicator)

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func call_highlight(indicator):
	emit_signal("become_highlighted", indicator)
	
