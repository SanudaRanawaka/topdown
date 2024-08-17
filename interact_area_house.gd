extends Interactable

var file_data = null
var d = null
#@onready var label = $Label
var exit = "konoha"

func call_interact():
	SceneManager.current_map = exit
	emit_signal("become_interacted",entrance_position)
