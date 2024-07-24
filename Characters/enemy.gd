extends CharacterBody2D
#---Export Variables Start---#
@export var move_speed : float = 300
@export var knockback_str : int = 100
@export var atk_power : int = 10
@export var health : int = 100
#---Export Variables End---#

#---Onready Variables Start---#
@onready var sprite_2d = $Sprite2D
@onready var animation_tree = $AnimationTree
@onready var health_bar = $HealthBar
@onready var stun_timer = $"stuntimer"


#---Onready Variables End---#

#---Variables Start---#
var knocking_direction = Vector2.ZERO
var knockback = Vector2.ZERO
var knockback_strength = 100
var mov_direction = Vector2()
var mov_distance = Vector2()
var see_player = false
var stunned = false
#---Variables End---#

@onready var max_health = 100
@onready var cur_health = max_health
var armor = 0
var cooldown = 1
var player = null
var is_attacking = false


func _ready():
	animation_tree.active= true
	health_bar.init_health(100)

func _physics_process(delta):
	
	#---tutorial start---#
	if health <= 0:
		Death()
	if cooldown >0:
		cooldown -= 1*delta
	if stunned == false:
		if is_attacking == false:
			if see_player:
				animation_tree.get("parameters/playback").travel("walk")
				accelerate_towards_points(player, delta)
				move_and_slide()
				if(mov_direction.x < 0):
					sprite_2d.flip_h = true
				elif(mov_direction.x > 0):
					sprite_2d.flip_h = false
				if mov_distance.length() <= 100:
					attack()
			else:
				animation_tree.get("parameters/playback").travel("idle")
				
		knocking_direction = mov_direction
		knockback = knockback.move_toward(Vector2.ZERO, 200*delta)
		animation_tree.set("parameters/idle/BlendSpace2D/blend_position", mov_direction)
		animation_tree.set("parameters/walk/BlendSpace2D/blend_position", mov_direction)
		animation_tree.set("parameters/attack/BlendSpace2D/blend_position", mov_direction)
	#---tutorial end---#

func accelerate_towards_points(point, delta):
	var movement = mov_direction * move_speed
	mov_distance = (point.position - position)
	mov_direction = (point.position - position).normalized()
	if mov_distance.length() <= 10:
		mov_direction = Vector2.ZERO
	
	velocity = movement + (knockback * 2)
	velocity = velocity.move_toward(mov_direction*move_speed, 200*delta)
	animation_tree.get("parameters/playback").travel("walk")
	animation_tree.set("parameters/idle/BlendSpace2D/blend_position", mov_direction)
	animation_tree.set("parameters/walk/BlendSpace2D/blend_position",  mov_direction)
	animation_tree.set("parameters/attack/BlendSpace2D/blend_position", mov_direction)

func _on_animation_tree_animation_finished(anim_name):
	#FOR SOME REASON THIS DOESNT RUN BUT IT STILL WORKS
	if "attack" in anim_name:
		is_attacking = false

func attack():
	if stunned == false:
		animation_tree.get("parameters/playback").travel("attack")
		is_attacking = true
		cooldown = 1

func _on_aggro_area_body_entered(body):
	if body.name == "Player":
		print("player seen")
		see_player = true
		player = body

func _on_aggro_area_body_exited(body):
	if body.name == "Player":
		see_player = false
		player = null
	velocity = Vector2.ZERO
	knockback = Vector2.ZERO
	mov_direction = Vector2.ZERO
	mov_distance = Vector2.ZERO

func _on_hurtbox_took_damage(amount, knockbacked):
	stunned = true
	print("stunned")
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

func _on_range_area_entered(area):
	area.take_damage(10, knockback_strength*knocking_direction)
	
func Death():
	queue_free()

func _on_stuntimer_timeout():
	stunned = false
