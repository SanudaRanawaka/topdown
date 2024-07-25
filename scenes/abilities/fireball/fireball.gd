extends Node
@onready var timer = $Timer


var fire_projectile = load("res://scenes/abilities/fireball/projectile.tscn")

var distance = 5000
var speed = 500
var cooldown = 5
var usable : bool = true

func execute(s, direction = null):
	if usable:
		if !direction:
			direction = Vector2(s.input_dir.x,s.input_dir.y)
		usable = false
		timer.start(cooldown)
		var f = fire_projectile.instantiate()

		f.position.x = s.position.x + direction.x *100
		f.position.y = s.position.y + direction.y *100
		f.configure(s, direction,distance,speed)
		get_node("/root").add_child(f)
	else:
		print("ability on cooldown: "+ str(round(timer.time_left)))
	


func _on_timer_timeout():
	usable = true
