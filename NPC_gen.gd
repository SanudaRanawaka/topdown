extends CharacterBody2D

@onready var timer = $Timer
@onready var label = $Label

const SPEED = 300.0
var current_state = MOVE

var direction = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player = null
var player_in_chat_zone = false

enum {
	IDLE,NEW_DIR,MOVE
}

func _ready():
	is_roaming = true
	start_pos = position
	timer.start()
	label.set_visible(false)
	
func _process(delta):
	#MIGHT BE BETTER TO HAVE A SIGNAL FROM PLAYER
	if player_in_chat_zone:
		if Input.is_action_just_pressed("interact"):
			if !is_chatting:
				chat()
				if player != null:
					player.activate_chat("warun_dialogue1")
					print(player)
			is_roaming = false
			is_chatting = true
			direction = Vector2.ZERO
			current_state = IDLE
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				direction = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])
			MOVE:
				move(delta)
	

func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	if !is_chatting:
		position += direction * SPEED * delta
		

func chat():
	is_chatting = true
	print("runs chat()")

func _on_timer_timeout():
	timer.wait_time = choose([0.5,1,1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])
	
	if !is_chatting:
		timer.start()

func _on_hurtbox_become_highlighted(indicator):
	if indicator:
		print(self.name + " am Highlighted")
		print(indicator)
	label.set_visible(indicator)
