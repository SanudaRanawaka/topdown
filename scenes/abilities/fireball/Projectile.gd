extends CharacterBody2D

var direction = null
var distance = null
var speed = null
var parent = null
var moved = 0
var look_vector = Vector2.ZERO
var knockback_strength =1000

func configure(s = null, my_dir = null, my_dist = null, my_speed = null):
	parent = s
	direction = my_dir
	distance = my_dist
	speed = my_speed
	look_vector = direction
	#look_at_from_position(s.position, direction)

#move in direction looking when used
func _physics_process(_delta):
	if moved < distance:
		move()
	if moved >= distance:
		self.queue_free()

func move():
	moved+=1
	velocity = Vector2()
	velocity.x = direction.x
	velocity.y = direction.y
	
	velocity = velocity.normalized()*speed
	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy"):
		queue_free()
		area.take_damage(20,knockback_strength*(look_vector.normalized()))
		print(knockback_strength*(look_vector.normalized()))

