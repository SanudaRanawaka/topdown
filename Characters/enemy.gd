extends CharacterBody2D

@export var move_speed : float = 1
@onready var sprite_2d = $Sprite2D
@onready var animation_tree = $AnimationTree

var cooldown = 1
var is_attacking = false
var player = null
var player_chase = false
var heading_towards

func _ready():
	animation_tree.active= true

func _physics_process(delta):
	if cooldown >0:
		cooldown -= 1*delta
	velocity = Vector2.ZERO
	if player_chase:
		heading_towards = player.position - position
		if(heading_towards.x < 0):
			sprite_2d.flip_h = true
		elif(heading_towards.x > 0):
			sprite_2d.flip_h = false
		if (abs(heading_towards.x) > 50 or abs(heading_towards.y) > 250):
			position += (heading_towards*delta)*move_speed
		if abs(heading_towards.x) < 200 and abs(heading_towards.y) < 250 and cooldown <= 0:
			attack()
			
	if is_attacking == false:
		if (player_chase == false):
			animation_tree.get("parameters/playback").travel("idle")
		else:
			animation_tree.get("parameters/playback").travel("walk")
			#setting all not efficient probably better way
		animation_tree.set("parameters/idle/BlendSpace2D/blend_position", heading_towards)
		animation_tree.set("parameters/walk/BlendSpace2D/blend_position", heading_towards)
		animation_tree.set("parameters/attack/BlendSpace2D/blend_position", heading_towards)
	move_and_slide()

func _on_animation_tree_animation_finished(anim_name):
	#FOR SOME REASON THIS DOESNT RUN BUT IT STILL WORKS
	if "attack" in anim_name:
		is_attacking = false
	
func attack():
	print("attack")
	animation_tree.get("parameters/playback").travel("attack")
	is_attacking = true
	cooldown = 1
	

func _on_aggro_area_body_entered(body):
	print("enemy sighted")
	player = body
	player_chase = true


func _on_aggro_area_body_exited(_body):
	player = null
	player_chase = false


func _on_range_body_entered(body):
	body.apply_damage(10)
