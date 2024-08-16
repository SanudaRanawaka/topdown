extends Interactable

var file_data = null
var d = null
#@onready var label = $Label
var exit = "konoha"

func _ready():
	#label.set_visible(false)
	file_data = load_data()

	print(d)

func call_interact():
	emit_signal("become_interacted")
	get_parent().set_scene_changed(true)
	get_parent().set_destination(d)

func load_data():
	var file_path = "res://Data/MapData/"+get_parent().name+"Data/"+self.name+".json"
	var file_data  = FileAccess.open(file_path, FileAccess.READ)
	var json_data  = JSON.new()
	if file_data != null:
		json_data.parse(file_data.get_as_text())
		file_data.close()
		d = file_data["Destination"]
		d["Destination"][0] = exit
		d["Destination"][2] = d["Destination"][3]
		file_data = null
		return json_data.get_data() 
