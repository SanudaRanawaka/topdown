extends CharacterBody2D
class_name Player

signal update_health(amount)

#---Export Variables Start---#
@onready var atk_timer = $atk_timer
@onready var sprite_2d = $Sprite2D
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@export var move_speed : int = 500
@export var friction : float = 0.125
@export var acceleration : int = 40
@export var atk_number: int = 3

#---Export Variables End---#
#---Variables Start---#
var is_moving = false
var is_attacking = false
#---Variables End---#
@onready var respawn_timer = $respawn

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
			animation_tree.set("parameters/attack2/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/attack3/BlendSpace2D/blend_position", input_direction)
		move()
	attack_combo()
	#---Movement End--#

#copy pasting probably a better way
func attack_combo():
	if Input.is_action_just_pressed("basic_attack") and atk_number == 3:
		is_attacking = true
		atk_timer.start()
		animation_tree.get("parameters/playback").travel("attack1")
	if Input.is_action_just_pressed("basic_attack") and atk_number == 2:
		is_attacking = true
		atk_timer.start()
		animation_tree.get("parameters/playback").travel("attack2")
	if Input.is_action_just_pressed("basic_attack") and atk_number == 1:
		is_attacking = true
		atk_timer.start()
		animation_tree.get("parameters/playback").travel("attack3")



func finished_attacking():
	is_attacking = false
	
func remove_atk_number():
	atk_number -= 1

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
	respawn_timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	print("Revived")


#func _on_hit_box_body_entered(body):
	#body.apply_damage(20)

func move():
	move_and_slide()


func _on_atk_timer_timeout():
	atk_number = 3
	is_attacking = false

#when entity hits a enemy hurtbox
func _on_hit_box_area_entered(area):
	area.take_damage(20)

#when entity gets hit by an enemy hitbox
func _on_hurtbox_took_damage(amount):
	apply_damage(amount)
