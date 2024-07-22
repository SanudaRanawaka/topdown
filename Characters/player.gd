extends CharacterBody2D
class_name Player

signal update_health(amount)

@export var move_speed : float = 50000
@export var starting_direction : Vector2 = Vector2(0,1)
@onready var sprite_2d = $Sprite2D
@onready var timer = $Timer
@onready var collision_shape_2d = $Sprite2D/HitBox/CollisionShape2D

@onready var max_health = 100
@onready var cur_health = max_health
var armor = 0

@onready var animation_tree = $AnimationTree
var is_attacking = false

func _ready():
	animation_tree.active= true
	emit_signal("update_health", cur_health)

func _physics_process(delta):
	
	if is_attacking:
		move_speed = 25000
	else: 
		move_speed = 50000
	
	var input_direction = Vector2(
	Input.get_action_strength("move_right")- Input.get_action_strength("move_left"),
	Input.get_action_strength("move_down")- Input.get_action_strength("move_up")
	).normalized()
	
	if Input.is_action_just_pressed("basic_attack"):
		animation_tree.get("parameters/playback").travel("basic_attack")
		is_attacking = true
		position += input_direction*10
			
	
	if is_attacking == false:
		if(input_direction.y < 0 and input_direction.x == 0):
			collision_shape_2d.position = Vector2(100,-250)
		elif(input_direction.y > 0 and input_direction.x == 0):
			collision_shape_2d.position = Vector2(120,200)
		elif(input_direction.x < 0):
			sprite_2d.scale.x = -1.1
			collision_shape_2d.position = Vector2(265,-100)
		else:
			sprite_2d.scale.x = 1.1
			collision_shape_2d.position = Vector2(265,-100)
			
		#velocity = input_direction*move_speed*delta
		
		if (input_direction == Vector2.ZERO):
			animation_tree.get("parameters/playback").travel("idle")
		else:
			animation_tree.get("parameters/playback").travel("walk")
			#setting all not efficient probably better way
			animation_tree.set("parameters/idle/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/walk/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/basic_attack/BlendSpace2D/blend_position", input_direction)
	velocity = input_direction*move_speed*delta
	move_and_slide()
	
func _on_animation_tree_animation_finished(anim_name):
	if "attack" in anim_name:
		is_attacking = false
		
func apply_damage(amount):
	if(armor>0):
		amount = amount * ((100-armor)*0.01)
	if(cur_health > amount):
		cur_health -= amount
		update_health.emit(amount*-1)
	else:
		cur_health = 0
		update_health.emit(amount*-1)
		print("YOU DIED")
		die()

func die():
	Engine.time_scale = 0.5
	print("YA SUCC")
	timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	print("Revived")


func _on_hit_box_body_entered(body):
	body.apply_damage(20)
