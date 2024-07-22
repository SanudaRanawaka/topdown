extends CharacterBody2D
class_name Player

signal update_health(amount)

#---Export Variables Start---#
@onready var sprite_2d = $Sprite2D
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@export var move_speed : int = 500
@export var friction : float = 0.125
@export var acceleration : int = 40
#---Export Variables End---#
#---Variables Start---#
var is_moving = false
var is_attacking = false
#---Variables End---#
@export var starting_direction : Vector2 = Vector2(0,1)

@onready var timer = $Timer
@onready var collision_shape_2d = $Marker2D/HitBox/CollisionShape2D


@onready var max_health = 100
@onready var cur_health = max_health
var armor = 0




func _ready():
	animation_tree.active= true
	emit_signal("update_health", cur_health)

func _physics_process(_delta):
	#---Movement Start--#
	if is_attacking == false:
		var input_direction = Vector2(
		Input.get_action_strength("move_right")- Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")- Input.get_action_strength("move_up")
		).normalized()
		
		velocity = input_direction*move_speed
		
		if (input_direction == Vector2.ZERO):
			animation_tree.get("parameters/playback").travel("idle")
		else:
			animation_tree.get("parameters/playback").travel("walk")
			animation_tree.set("parameters/idle/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/walk/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/attack1/BlendSpace2D/blend_position", input_direction)
		move_and_slide()
	if Input.is_action_just_pressed("basic_attack"):
		is_attacking = true
		animation_tree.get("parameters/playback").travel("attack1")
	#---Movement End--#
	#if is_attacking:
		#move_speed = 25000
	#else: 
		#move_speed = 50000
	
	
	
	#if Input.is_action_just_pressed("basic_attack"):
		#animation_tree.get("parameters/playback").travel("basic_attack")
		#is_attacking = true
		#position += input_direction*10
			
	

	#velocity = input_direction*move_speed*delta
	#move_and_slide()
	
func finished_attacking():
	is_attacking = false
	
	
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
