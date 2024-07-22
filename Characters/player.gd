extends CharacterBody2D
class_name Player

signal update_health(amount)

@export var move_speed : float = 50000
@export var starting_direction : Vector2 = Vector2(0,1)
@onready var sprite_2d = $Sprite2D
@onready var timer = $Timer

@onready var max_health = 100
@onready var cur_health = max_health
var armor = 0

@onready var animation_tree = $AnimationTree
var is_attacking = false

func _ready():
	animation_tree.active= true
	emit_signal("update_health", cur_health)

func _physics_process(delta):
	if Input.is_action_just_pressed("basic_attack"):
		move_speed = move_speed/8
		animation_tree.get("parameters/playback").travel("basic_attack")
		is_attacking = true
	
	var input_direction = Vector2(
	Input.get_action_strength("move_right")- Input.get_action_strength("move_left"),
	Input.get_action_strength("move_down")- Input.get_action_strength("move_up")
	).normalized()
	
	if is_attacking == false:
		if(input_direction.x < 0):
			sprite_2d.flip_h = true
		elif(input_direction.x > 0):
			sprite_2d.flip_h = false
		velocity = input_direction*move_speed*delta
		
		if (input_direction == Vector2.ZERO):
			animation_tree.get("parameters/playback").travel("idle")
		else:
			animation_tree.get("parameters/playback").travel("walk")
			#setting all not efficient probably better way
			animation_tree.set("parameters/idle/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/walk/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/basic_attack/BlendSpace2D/blend_position", input_direction)
	move_and_slide()
	
func _on_animation_tree_animation_finished(anim_name):
	if "attack" in anim_name:
		is_attacking = false
		move_speed = move_speed*2
		
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
