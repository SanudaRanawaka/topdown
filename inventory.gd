#How to Make an Inventory System in Godot by Arkeve

extends Control
const SlotClass = preload("res://Slot.gd")

@onready var inventory_slots = $GridContainer
var holding_item = null
# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_visible(false)
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].gui_input.connect(slot_gui_input.bind(slots[i]))
		slots[i].slot_index = i
	initialize_inventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			# action to be holding item
			if holding_item != null:
				# place into empty slot
				if !slot.item: 
					#place holding item into slot
					left_click_empty_slot(slot)
				else:
					# item put inot slot with another item
					if holding_item.item_name != slot.item.item_name:
						# different items so keep swap function
						left_click_different_item(event,slot)
					else:
						#same item so attempt merge
						left_click_same_item(slot)
			#not holding item
			elif slot.item:
				left_click_not_holding(slot)
				
				
func _input(event):
	#if event.is_action_pressed("inventory") and holding_item == null:
		#self.set_visible(!(self.visible))
	if holding_item:
		holding_item.global_position = get_global_mouse_position() - Vector2(64,64)

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

func left_click_empty_slot(slot):
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	slot.put_into_slot(holding_item)
	holding_item = null
	
func left_click_different_item(event: InputEvent, slot:SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(holding_item,slot)
	var temp_item = slot.item
	slot.pick_from_slot()
	temp_item.global_position = event.global_position
	slot.put_into_slot(holding_item)
	holding_item = temp_item
	
func left_click_same_item(slot: SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, holding_item.item_quantity)
		slot.item.add_item_quantity(holding_item.item_quantity)
		holding_item.queue_free()
		holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		holding_item.add_item_quantity(-1*able_to_add)

func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	holding_item = slot.item
	slot.pick_from_slot()
	holding_item.global_position = get_global_mouse_position() - Vector2(64,64)
