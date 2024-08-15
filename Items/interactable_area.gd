extends Area2D
signal become_highlighted(indicator)
signal become_interacted()
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func call_highlight(indicator):
	emit_signal("become_highlighted", indicator)
	print("highlight called")
	
func call_interact():
	emit_signal("become_interacted")
