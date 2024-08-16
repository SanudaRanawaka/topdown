extends Interactable

var file_data = null
var d = null
#@onready var label = $Label
var exit = "konoha"

func _ready():
	#label.set_visible(false)
	file_data = load_data()
	d = file_data["Destination"]
	d[0] = "konoha"
	d[2] = d[3]
	print(d)

func call_interact():
	emit_signal("become_interacted")
	if d != null:
		get_parent().set_scene_changed(true)
		get_parent().set_destination(d)

func load_data():
	var file_path = "res://Data/MapData/"+exit+"Data/"+get_parent().name+".json"
	file_data  = FileAccess.open(file_path, FileAccess.READ)
	
	print("file path is")
	print(file_path)
	
	var json_data  = JSON.new()
	if file_data == null:
		print("read Failed")
		print(json_data)
		return{}
	json_data.parse(file_data.get_as_text())
	file_data.close()
	file_data = null
	return json_data.get_data() 
