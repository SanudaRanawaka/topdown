extends Map

func _process(_delta):
	if scene_changed:
		if destination != null:
			save_state(current_data)
			#call manager to change scenes
			emit_signal("change_scene",destination)
	scene_changed = false
