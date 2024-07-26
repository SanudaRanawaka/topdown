extends Control
const SlotClass = preload("res://Slot.gd")

@onready var inventory_slots = $GridContainer
var holding_item = null
# Called when the node enters the scene tree for the first time.
func _ready():
	for inv_slot in inventory_slots.get_children():
		inv_slot.gui_input.connect(slot_gui_input.bind(inv_slot))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if holding_item != null:
				if !slot.item: #place holding item into slot
					slot.put_into_slot(holding_item)
					holding_item = null
				else:
					var temp_item = slot.item
					slot.pick_from_slot()
					temp_item.global_position = event.global_position
					slot.put_into_slot(holding_item)
					holding_item = temp_item
			elif slot.item:
				holding_item = slot.item
				slot.pick_from_slot()
				holding_item.global_position = get_global_mouse_position() - Vector2(64,64)
				
func _input(_event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position() - Vector2(64,64)
