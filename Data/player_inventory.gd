#How to Make an Inventory System in Godot by Arkeve

extends Node
const SlotClass = preload("res://scripts/Slot.gd")
const ItemClass = preload("res://scripts/Item.gd")

const NUM_INVENTORY_SLOTS = 20

var inventory = {
	0: ["4 Star Dragon Ball", 1],
	1: ["4 Star Dragon Ball", 1],
	2: ["4 Star Dragon Ball", 1],
	3: ["4 Star Dragon Ball", 98],
	4: ["Senzu Bean", 98]
}

func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				return
			else:
				inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add
	
	#if we dont have the item already
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			return
	
func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	inventory[slot.slot_index] = [item.item_name, item.item_quantity]
	
func remove_item(slot: SlotClass):
	inventory.erase(slot.slot_index)

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	inventory[slot.slot_index][1] += quantity_to_add
