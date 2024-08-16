extends Interactable

var file_data = null
var d = null
#@onready var label = $Label
var exit = "konoha"

func _ready():
	#label.set_visible(false)
	pass

func call_interact():
	emit_signal("become_interacted",entrance_position)
	pass

func load_data():
	pass
