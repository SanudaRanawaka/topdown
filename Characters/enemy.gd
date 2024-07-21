extends CharacterBody2D

@export var move_speed : float = 100
@onready var sprite_2d = $Sprite2D
@onready var animation_tree = $AnimationTree
var is_attacking = false
var player = null
var player_chase = false

func _ready():
	animation_tree.active= true

func _physics_process(delta):
	if player_chase:
		if (player.position - position).abs() > Vector2(150,150).abs():
			position += (player.position - position)/move_speed
		
	if is_attacking == false:
		
		if (velocity == Vector2.ZERO):
			animation_tree.get("parameters/playback").travel("idle")
		else:
			animation_tree.get("parameters/playback").travel("idle")
			#setting all not efficient probably better way
			animation_tree.set("parameters/idle/BlendSpace2D/blend_position", position)
			animation_tree.set("parameters/walk/BlendSpace2D/blend_position", position)
			animation_tree.set("parameters/attack/BlendSpace2D/blend_position", position)
	move_and_slide()
	
func _on_animation_tree_animation_finished(anim_name):
	if "attack" in anim_name:
		is_attacking = false
		


func _on_range_body_entered(body):
	print("attack")
	animation_tree.get("parameters/playback").travel("attack")
	is_attacking = true

func _on_aggro_area_body_entered(body):
	print("enemy sighted")
	player = body
	player_chase = true


func _on_aggro_area_body_exited(body):
	player = null
	player_chase = false
