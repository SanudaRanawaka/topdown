extends Control

@onready var NPRname = $NinePatchRect/Name
@onready var NPRtext = $NinePatchRect/Text

@export_file("*.json") var d_file

var dialogue = []
var current_dialogue_id = -1
var d_active = false

func _ready():
	self.set_visible(false)

func start():
	if d_active:
		return
	d_active = true
	self.set_visible(true)
	var current_dialogue_id = -1
	dialogue = load_dialogue()
	next_script()

func load_dialogue():
	var file = FileAccess.open("res://Characters/Dialogue/warun_dialogue1.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		next_script()

func next_script():
	current_dialogue_id +=1
	if current_dialogue_id >= len(dialogue):
		d_active = false
		self.set_visible(false)
		UiManager.finished_chat()
		current_dialogue_id = -1
		return
	NPRname.text = dialogue[current_dialogue_id]['name']
	NPRtext.text = dialogue[current_dialogue_id]['text']
