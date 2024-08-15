extends Map




func _on_area_2d_become_highlighted(indicator):
	label.set_visible(indicator)

func _on_area_2d_become_interacted():
	scene_changed= true
