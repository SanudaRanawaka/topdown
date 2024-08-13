extends Control
const SlotClass = preload("res://Slot.gd")

@onready var inventory_slots = $GridContainer
var holding_item = null
# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_visible(false)
	for inv_slot in inventory_slots.get_children():
		inv_slot.gui_input.connect(slot_gui_input.bind(inv_slot))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			# action to be holding item
			if holding_item != null:
				# place into empty slot
				if !slot.item: #place holding item into slot
					slot.put_into_slot(holding_item)
					holding_item = null
				else:
					# item put inot slot with another item
					if holding_item.item_name != slot.item.item_name:
						# different items so keep swap function
						var temp_item = slot.item
						slot.pick_from_slot()
						temp_item.global_position = event.global_position
						slot.put_into_slot(holding_item)
						holding_item = temp_item
					else:
						#same item so attempt merge
						var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
						var able_to_add = stack_size - slot.item.item_quantity
						if able_to_add >= holding_item.item_quantity:
							slot.item.add_item_quantity(holding_item.item_quantity)
							holding_item.queue_free()
							holding_item = null
						else:
							slot.item.add_item_quantity(able_to_add)
							holding_item.add_item_quantity(-1*able_to_add)
						
			#not holding item
			elif slot.item:
				holding_item = slot.item
				slot.pick_from_slot()
				holding_item.global_position = get_global_mouse_position() - Vector2(64,64)
				
func _input(event):
	if event.is_action_pressed("inventory") and holding_item == null:
		self.set_visible(!(self.visible))
	if holding_item:
		holding_item.global_position = get_global_mouse_position() - Vector2(64,64)
