extends CharacterBody2D
class_name Player

signal update_health(amount)
signal start_dialogue(dialogue_name)
#---Export Variables Start---#
@onready var atk_timer = $atk_timer
@onready var sprite_2d = $Sprite2D
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var interact_detect = $InteractDetect

@export var move_speed : int = 500
#@export var friction : float = 0.125
#@export var acceleration : int = 40
@export var morale: int = 100
@export var card_collection = []
@export var atk_number: int = 3
@export var atk_power: int = 20
@export var knockback_strength: int = 50
@onready var hurtbox = $Hurtbox

#---Export Variables End---#
#---Variables Start---#
var is_moving = false
var is_attacking = false
var knockback_direction = Vector2.ZERO
var knockback = Vector2.ZERO
var nearest_item_test = null
#---Variables End---#
@onready var respawn_timer = $respawn
@onready var input_dir = Vector2.ZERO
@onready var max_health = 100
@onready var cur_health = max_health
@onready var ability_names = ["","","",""]
@onready var abilities = [0,0,0,0]
var armor = 0

func _ready():
	animation_tree.active= true
	emit_signal("update_health", cur_health)
	ability_names = ["","","",""]
	abilities = [0,0,0,0]
	abilities[0] = load_ability("fireball",0)
	SceneManager.player = self


func _physics_process(delta):
	#---Movement Start--#
	if cur_health <= 0:
		die()
	knockback = knockback.move_toward(Vector2.ZERO, 200*delta)
	if is_attacking == false:
		var input_direction = Vector2(
		Input.get_action_strength("move_right")- Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")- Input.get_action_strength("move_up")
		).normalized()
		
		velocity = input_direction*move_speed + knockback 
		
		if (input_direction == Vector2.ZERO):
			animation_tree.get("parameters/playback").travel("idle")
		else:
			input_dir = input_direction
			animation_tree.get("parameters/playback").travel("walk")
			animation_tree.set("parameters/idle/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/walk/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/attack1/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/attack2/BlendSpace2D/blend_position", input_direction)
			animation_tree.set("parameters/attack3/BlendSpace2D/blend_position", input_direction)
		move()
	attack_combo()
	#---Movement End--#

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ability1"):
		use_move(0)
	if interact_detect.interact_list != []:
		highlight_interact()
	#print(nearest_item_test)
	if Input.is_action_just_pressed("interact"):
		if nearest_item_test != null and nearest_item_test.is_in_group("Interactable"):
			var result = nearest_item_test.call_interact()

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

func apply_damage(amount, knockedback):
	if(armor>0):
		amount = amount * ((100-armor)*0.01)
	knockback = knockedback
	if(cur_health > amount):
		cur_health -= amount
		update_health.emit(amount*-1)
	else:
		cur_health = 0
		update_health.emit(amount*-1)
		print("YOU DIED")
		die()

func die():
	hurtbox.disable_mode = true
	Engine.time_scale = 0.5
	print("YA SUCC")
	respawn_timer.start()
	print(respawn_timer.time_left)

func move():
	move_and_slide()

func _on_atk_timer_timeout():
	atk_number = 3
	is_attacking = false

#when entity hits a enemy hurtbox
func _on_hit_box_area_entered(area):
	if area.is_in_group("Enemy"):
		knockback_direction = input_dir
		area.take_damage(20,knockback_strength*knockback_direction)
		

#when entity gets hit by an enemy hitbox
func _on_hurtbox_took_damage(amount, knockedback):
	apply_damage(amount, knockedback)


func _on_respawn_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	print("Revived")
	
#--- NEW SHIT ---#
func load_ability(move_name, slot_number = 0):
	var scene = load("res://scenes/abilities/"+move_name+"/"+move_name+".tscn")
	print(scene)
	if scene != null:
		var sceneNode = scene.instantiate()
		add_child(sceneNode)
		if(slot_number>=0):
			ability_names[slot_number]=move_name
			abilities[slot_number] = sceneNode
			print(sceneNode.name)
		else:
			print("unable to load ability to given slot")
		return sceneNode
	return -1

func use_move(slot):
	print(position)
	if ability_names[slot] == "":
		print("no move equipped")
	else:
		print("WAAAAAAH")
		abilities[slot].execute(self, input_dir)
		
func add_card(number):
	card_collection.append(number)
	card_collection.sort()
	print(card_collection)
	
func highlight_interact():
	var nearest_item = null
	var item_dist = 4096
	var item_dist_new = 4096
	for i in interact_detect.interact_list:
		item_dist_new = (i.get_parent().position - self.position).length()
		if item_dist_new <= item_dist:
			#if nearest_item != null:
				#nearest_item.call_highlight(false)
			nearest_item = i
			#nearest_item.call_highlight(true)
			if nearest_item != nearest_item_test and nearest_item_test != null :
				nearest_item_test.call_highlight(false)
	nearest_item_test = nearest_item
	if nearest_item_test.is_in_group("Interactable"):
		nearest_item_test.call_highlight(true)
	

func _on_interact_detect_no_interact():
	if nearest_item_test.is_in_group("Interactable"):
		nearest_item_test.call_highlight(false)
	nearest_item_test = null

#func interact(interactable):
#	
