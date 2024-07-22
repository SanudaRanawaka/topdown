extends CanvasLayer
class_name UI
@onready var health_bar = $Control/HealthBar
@onready var hp_label = %Label

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
	
