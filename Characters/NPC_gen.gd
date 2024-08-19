extends CharacterBody2D

@onready var timer = $Timer
@onready var label = $Label
@onready var cooldown = $Cooldown

const SPEED = 3000.0
var current_state = MOVE

var direction = Vector2.RIGHT

var is_roaming = true
var is_chatting = false


enum {
	IDLE,NEW_DIR,MOVE
}

func _ready():
	is_roaming = true
	timer.start()
	label.set_visible(false)
	
func _process(delta):
	#MIGHT BE BETTER TO HAVE A SIGNAL FROM PLAYER
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				direction = choose([Vector2.UP, Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN])
			MOVE:
				move(delta)
	

func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	velocity =  direction * SPEED *delta
	move_and_slide()
		

func chat():
	is_chatting = true
	UiManager.activate_chat("warun_dialogue1")
	if !UiManager.finish_dialogue.is_connected(self.finished_chat):
		UiManager.finish_dialogue.connect(self.finished_chat)
	is_roaming = false
	direction = Vector2.ZERO
	current_state = IDLE

func _on_timer_timeout():
	timer.wait_time = choose([0.5,1,1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])
	if !is_chatting:
		timer.start()

func _on_hurtbox_become_highlighted(indicator):
	label.set_visible(indicator)


func _on_hurtbox_start_interact():
	if !is_chatting:
		chat()

func finished_chat():
	cooldown.start()
	is_roaming = true
	if UiManager.finish_dialogue.is_connected(self.finished_chat):
		UiManager.finish_dialogue.disconnect(self.finished_chat)


func _on_cooldown_timeout():
	is_chatting =false
