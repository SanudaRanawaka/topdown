extends CharacterBody2D

@export var move_speed : float = 500
@export var starting_direction : Vector2 = Vector2(0,1)
@onready var sprite_2d = $Sprite2D

@onready var animation_tree = $AnimationTree

func _ready():
	animation_tree.active= true
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_direction = Vector2(
	Input.get_action_strength("move_right")- Input.get_action_strength("move_left"),
	Input.get_action_strength("move_down")- Input.get_action_strength("move_up")
	)
	
	if(input_direction.x < 0):
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
	update_animation_parameters(input_direction)
	velocity = input_direction*move_speed
	
	if (input_direction == Vector2.ZERO):
		animation_tree.get("parameters/playback").travel("idle")
	else:
		animation_tree.get("parameters/playback").travel("walk")
		#setting all not efficient probably better way
	animation_tree.set("parameters/idle/BlendSpace2D/blend_position", input_direction)
	animation_tree.set("parameters/walk/BlendSpace2D/blend_position", input_direction)
	animation_tree.set("parameters/attack/BlendSpace2D/blend_position", input_direction)
	move_and_slide()
	
func update_animation_parameters(move_input : Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/idle/blend_position", move_input)
