extends CharacterBody2D
#---Export Variables Start---#
@export var move_speed : float = 300
@export var health : int = 100
#---Export Variables End---#

#---Onready Variables Start---#
@onready var sprite_2d = $Sprite2D
@onready var health_bar = $HealthBar
@onready var stun_timer = $"stuntimer"


#---Onready Variables End---#

#---Variables Start---#
var knocking_direction = Vector2.ZERO
var knockback = Vector2.ZERO
var mov_direction = Vector2()
var stunned = false
#---Variables End---#

@onready var max_health = 100
@onready var cur_health = max_health
var armor = 0


func _ready():
	health_bar.init_health(100)

func _physics_process(delta):
	
	#---tutorial start---#
	if health <= 0:
		Death()

	#move_and_slide()
	if(mov_direction.x < 0):
		sprite_2d.flip_h = true
	elif(mov_direction.x > 0):
		sprite_2d.flip_h = false

	velocity = Vector2.ZERO
	knocking_direction = mov_direction
	knockback = knockback.move_toward(Vector2.ZERO, delta*100)
	velocity.move_toward(knockback, delta*100)
	#---tutorial end---#
	velocity += knockback*2
	move_and_slide()
	
func accelerate_towards_points(point, delta):
	var movement = mov_direction * move_speed
	mov_direction = (point.position - position).normalized()
	
	velocity = movement
	velocity = velocity.move_toward(mov_direction*move_speed, delta)



func _on_hurtbox_took_damage(amount, knockbacked):
	stunned = true
	stun_timer.wait_time = 0.5
	print(knockbacked.length())
	stun_timer.start()
	if(armor>0):
		amount = amount * ((100-armor)*0.01)
	knockback = knockbacked
	if(cur_health > amount):
		cur_health -= amount
		health_bar._set_health(cur_health)
	else:
		cur_health = 0
		health_bar._set_health(0)
		Death()
	
func Death():
	queue_free()

func _on_stuntimer_timeout():
	print("stund omne")
	stunned = false
	knockback = Vector2.ZERO
