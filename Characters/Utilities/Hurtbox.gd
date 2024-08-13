extends Area2D
signal took_damage(amount, knockback)
signal become_highlighted(indicator)

func take_damage(amount, knockback):
	#print(knockback)
	emit_signal("took_damage", amount, knockback)
	
func call_highlight(indicator):
	emit_signal("become_highlighted", indicator)
	print("npc highlight")
