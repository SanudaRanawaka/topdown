extends Node2D
#@onready var sprite_2d = $Sprite2D
@onready var sprite_2d = $TextureRect
@onready var label = $Label

var item_name
var item_quantity

# Called when the node enters the scene tree for the first time.
func _ready():
	if randi() % 8 ==0:
		item_name = "1 Star Dragon Ball"
	elif randi() %8 ==1:
		item_name = "2 Star Dragon Ball"
	elif randi() %8 ==2:
		item_name = "3 Star Dragon Ball"
	elif randi() %8 ==3:
		item_name = "4 Star Dragon Ball"
	elif randi() %8 ==4:
		item_name = "5 Star Dragon Ball"
	elif randi() %8 ==5:
		item_name = "6 Star Dragon Ball"
	elif randi() %8 ==6:
		item_name = "7 Star Dragon Ball"
	else:
		item_name = "Senzu Bean"

	#---END OF RANDOM SHIT---#
	sprite_2d.texture = load("res://Assets/item_icons/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		label.set_visibile(false)
	else:
		label.text = str(item_quantity)
		label.set_visible(true)

func add_item_quantity(add_amount):
	item_quantity += add_amount
	label.text = str(item_quantity)
	
func set_item(nm,qt):
	item_name = nm
	item_quantity = qt
	sprite_2d.texture = load("res://Assets/item_icons/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		label.set_visible(false)
	else:
		label.set_visible(true)
		label.text = str(item_quantity)
