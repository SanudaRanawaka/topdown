extends Node
signal start_dialogue(dialogue_name)
signal finish_dialogue()
var current_npc = null
# Called when the node enters the scene tree for the first time.
func activate_chat(chat_name):
	emit_signal("start_dialogue",chat_name)
func finished_chat():
	emit_signal("finish_dialogue")
