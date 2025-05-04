extends CharacterBody2D

signal hit
signal life_lost
signal life_gained
signal shot_fired
signal shot_gained

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer
@onready var shoot_timer = $ShootTimer
@onready var melee_timer = $MeleeTimer
@onready var melee_hitbox = $MeleeHitbox

@export var gravity = 4200

@export var speed = 800.0
@export var jump_velocity = -1800
@export var jump_horizontal = 100
@export var projectile = preload("res://Player//projectile/projectile.tscn")
@onready var ProjectileOrigin : Marker2D = $ProjectileOrigin


var lives = 5
var max_lives = 5
var ammo_count = 5
var can_shoot = true
var canReveal = false
var debug = false
var is_alive = false
var previous_state 

enum State {Idle, Run, Jump, Falling, Shoot, Melee}
var current_state : State
var character_sprite : Sprite2D
var muzzle_position

func _ready():
	Global.Player = self
	current_state = State.Idle
	$DebugLabel.hide()
	#life_lost.connect($HUD/Lives._on_player_life_lost)
	#life_gained.connect($HUD/Lives._on_player_life_gained)
	
	#shot_fired.connect($HUD/Ammo._on_shot_fired)
	#shot_gained.connect($HUD/Ammo._on_shot_gained)

func _physics_process(delta: float):
	if debug == false:
		var was_on_floor = is_on_floor()
		player_falling(delta)
		player_idle(delta)
		player_run(delta)
		player_jump(delta)
		player_shoot(delta)
		player_melee(delta)
		player_animations()
		projectile_origin_position()
		player_death()
		melee_hitbox_flip()
		move_and_slide()
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

	#THIS CODE is for making footstep sounds during left/right movement. It isn't functional yet. Dang it.
	var is_moving = Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")
	if is_moving:
		$RunningSound.play()
		$RunningSound.stream_paused = false
	else:
		$RunningSound.stream_paused = true

func player_falling(delta: float): 
	if !is_on_floor() and current_state != State.Shoot and current_state != State.Melee:
		velocity.y += gravity * delta
		current_state = State.Falling

func player_idle(delta: float):
	if is_on_floor() and current_state != State.Shoot and current_state != State.Melee:
		current_state = State.Idle

func player_run(delta: float):	
	var direction = input_movement()
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if direction != 0 and is_on_floor() and current_state != State.Shoot and current_state != State.Melee:
		current_state = State.Run
		animated_sprite_2d.flip_h = direction < 0

func player_jump(delta: float):
	var direction = input_movement()

	# Coyote and Double Jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()) and current_state != State.Shoot and current_state != State.Melee:
		velocity.y = jump_velocity
		current_state = State.Jump

	# Allow horizontal control during jump
	if !is_on_floor() and current_state == State.Jump:
		velocity.x += direction * jump_horizontal * delta
		
func player_shoot(_delta: float):
	var direction = input_movement()
	print(ammo_count)
	
	if Input.is_action_just_pressed("shoot") and current_state != State.Shoot and ammo_count > 0:
		shot_fired.emit(ammo_count)
		
		previous_state = current_state
		
		var projectile_instance = projectile.instantiate() as Node2D
		projectile_instance.global_position = ProjectileOrigin.global_position/3
		
		var world = get_tree().current_scene
		world.add_child(projectile_instance)
		
		projectile_instance.direction = direction
		
		if animated_sprite_2d.flip_h == false:
			projectile_instance.direction = direction + 1
		else:
			projectile_instance.direction = direction - 1
			
		current_state = State.Shoot
		shoot_timer.start() # Start the timer to track shoot animation duration
	
func player_melee(_delta):
	var direction = input_movement() #This line isn't being used?
	
	if Input.is_action_just_pressed("melee") and current_state != State.Melee:

		previous_state = current_state
		current_state = State.Melee
		#print("pressing melee")
		melee_timer.start()
		$MeleeHitbox/MeleeShape.disabled = false
		
func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("Run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("Jump")
	elif current_state == State.Falling:

		animated_sprite_2d.play("Jump")
	elif current_state == State.Shoot:
		animated_sprite_2d.play("Shoot")
	elif current_state == State.Melee:
		animated_sprite_2d.play("Melee")

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

func get_reveal():
	return canReveal

func set_reveal(isAquired):
	canReveal = isAquired
		
func player_death():
	if lives <= 0:
		pass

func projectile_origin_position():
	if animated_sprite_2d.flip_h:
		ProjectileOrigin.position.x = -abs(ProjectileOrigin.position.x)
	else:
		ProjectileOrigin.position.x = abs(ProjectileOrigin.position.x)

func melee_hitbox_flip():
	if animated_sprite_2d.flip_h:
		melee_hitbox.scale.x = -1
	else:
		melee_hitbox.scale.x = 1

func lose_life(damage_amount):
	lives = lives - damage_amount
	life_lost.emit(lives)
	
func gain_life():
	if lives != max_lives:
		lives = lives +1
		life_gained.emit(lives)
	else: 
		pass
func gain_ammo():
	ammo_count = ammo_count +1
	shot_gained.emit(ammo_count)
	
func _on_shoot_timer_timeout():

	if is_on_floor():
		var direction = input_movement()
		if direction != 0:
			current_state = State.Run
		else:
			current_state = State.Idle
	else:
		if velocity.y < 0:
			current_state = State.Jump
		else:
			current_state = State.Falling
	
func _on_melee_timer_timeout():
	$MeleeHitbox/MeleeShape.disabled = true
	if is_on_floor():
		var direction = input_movement()
		if direction != 0:
			current_state = State.Run
		else:
			current_state = State.Idle
	else:
		if velocity.y < 0:
			current_state = State.Jump
		else:
			current_state = State.Falling
