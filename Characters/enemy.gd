extends CharacterBody2D

@export var move_speed : float = 50000
@export var starting_direction : Vector2 = Vector2(0,1)
@onready var sprite_2d = $Sprite2D
@onready var input_direction : Vector2 = Vector2(0,0)
@onready var animation_tree = $AnimationTree
var is_attacking = false

func _ready():
	animation_tree.active= true

func _physics_process(delta):
	if is_attacking == false:
		if(input_direction.x < 0):
			sprite_2d.flip_h = true
		elif(input_direction.x > 0):
			sprite_2d.flip_h = false
		
		if (input_direction == Vector2.ZERO):
			animation_tree.get("parameters/playback").travel("idle")
		else:
			animation_tree.get("parameters/playback").travel("idle")
			#setting all not efficient probably better way
			animation_tree.set("parameters/idle/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/walk/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/attack/BlendSpace2D/blend_position", input_direction)
	move_and_slide()
	
func _on_animation_tree_animation_finished(anim_name):
	if "attack" in anim_name:
		is_attacking = false
		move_speed = move_speed*2
		


func _on_range_body_entered(body):
	print("attack")
	move_speed = move_speed/8
	animation_tree.get("parameters/playback").travel("attack")
	is_attacking = true

func _on_aggro_area_body_entered(body):
	input_direction = (body.position -self.position).normalized()
	self.velocity = (input_direction)*move_speed
	print("enemy sighted")
