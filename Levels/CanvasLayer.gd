extends CanvasLayer
class_name UI
@onready var health_bar = $Control/HealthBar
@onready var hp_label = %Label
@onready var dialog_box = $Control/DialogBox
@onready var inventory = $Control/Inventory

var hp = 100:
	set(new_hp):
		hp = new_hp
		_update_hp_label()

func _ready():
	_update_hp_label()
	health_bar.init_health(hp)

func _update_hp_label():
	hp_label.text = str(hp)
	if hp >= 0:
		health_bar._set_health(hp)

func _on_update_health(amount) -> void:
	if amount:
		hp += amount

func _on_start_dialogue(dialogue_name) -> void:
	print("chatting")
	dialog_box.start()

func _input(event):
	if event.is_action_pressed("inventory") and inventory.holding_item == null:
		inventory.set_visible(!(inventory.visible))
		inventory.initialize_inventory()

