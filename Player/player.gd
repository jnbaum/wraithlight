extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer

@export var gravity = 4200

@export var speed = 800.0
@export var jump_velocity = -1800
@export var jump_horizontal = 100

var debug = false

enum State {Idle,Run,Jump,Falling}
var current_state : State
var character_sprite : Sprite2D

func _ready():
	current_state = State.Idle
	$DebugLabel.hide()

func _physics_process(delta: float):
	
	if debug == false:
		var was_on_floor = is_on_floor()
		player_falling(delta)
		player_idle(delta)
		player_run(delta)
		player_jump(delta)
		move_and_slide()
		player_animations()
	#print("State: ", State.keys()[current_state]) #State Machine Debug
	
		if was_on_floor && !is_on_floor():
			coyote_timer.start()
	
	else:
		if Input.is_action_just_pressed("move_down"):
			position.y = position.y + 200
		if Input.is_action_just_pressed("move_up"):
			position.y = position.y - 200
		if Input.is_action_just_pressed("move_right"):
			position.x = position.x + 200
		if Input.is_action_just_pressed("move_left"):
			position.x = position.x - 200
		pass

func player_falling(delta: float): 
	if !is_on_floor():
		velocity.y += gravity * delta
		current_state = State.Falling
		#print("State: ", State.keys()[current_state]) #State Machine Debug

func player_idle(delta: float):
	if is_on_floor():
		current_state = State.Idle
		#print("State: ", State.keys()[current_state]) #State Machine Debug
		
		
func player_run(delta: float):	
	var direction = input_movement()
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x,0,speed)
	
	if direction != 0 and is_on_floor():
		current_state = State.Run	
		#print("State: ", State.keys()[current_state]) #State Machine Debug
		animated_sprite_2d.flip_h = direction < 0

#testing

func player_jump1(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		current_state = State.Jump
		#print("State: ", State.keys()[current_state]) #State Machine Debug
		
	if !is_on_floor() and current_state == State.Jump: #Horizontal Movement
		var direction = input_movement()
		velocity.x += direction * jump_horizontal * delta

func player_jump(delta):
	var direction = input_movement()

	# Coyote jump: Allow jump if player is on floor OR coyote timer hasn't expired
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = jump_velocity
		current_state = State.Jump
		#print("State: ", State.keys()[current_state]) # State Machine Debug

	# Allow horizontal control during jump
	if !is_on_floor() and current_state == State.Jump:
		velocity.x += direction * jump_horizontal * delta
	

func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("Run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("Jump")

func input_movement():
		var direction: float = Input.get_axis("move_left","move_right")
		return direction

func _unhandled_input(event):
	if event.is_action_pressed("debug"):
		if debug == false:
			debug = true
			$DebugLabel.show()
		else:
			debug = false
			$DebugLabel.hide()

func update_position():
	return position

func load_position(posx):
	position.x = posx

func _on_hurt_box_body_entered(body: Node2D):
	if body.is_in_group("Enemy"):
		print("enemy entered", body.damage_amount)
		HealthManager.decrease_health(body.damage_amount)
