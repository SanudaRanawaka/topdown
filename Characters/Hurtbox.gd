extends Area2D
signal took_damage(amount, knockback)

func take_damage(amount, knockback):
	#print(knockback)
	emit_signal("took_damage", amount, knockback)
	
	
