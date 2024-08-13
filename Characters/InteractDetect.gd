extends Area2D
var interact_list = []

# CAN HAVE THIS DISABLED UNTIL PRESSED , BUT IF WE ALWAYS HAVE ACTIVE WE CAN MAKE TEXT APPEAR TO INTERACT AND STUFF
signal interact_available(amount, knockback)


func _on_area_entered(area):
	interact_list.append(area)

func _on_area_exited(area):
	var i = interact_list.find(area)
	if i >=0:
		interact_list.remove_at(i)
