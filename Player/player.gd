extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer

@export var gravity = 4200

@export var speed = 800.0
@export var jump_velocity = -1800
@export var jump_horizontal = 100
@export var projectile = preload("res://Player//projectile/projectile.tscn")
@onready var ProjectileOrigin : Marker2D = $ProjectileOrigin
var health_amount = 10

var canReveal = false
var debug = false


enum State {Idle,Run,Jump,Falling,Shoot,Melee}
var current_state : State
var character_sprite : Sprite2D
var muzzle_position


func _ready():
	current_state = State.Idle
	Global.playerBody = self
	#animated_sprite_2d.play("Idle")
	$DebugLabel.hide()


func _physics_process(delta: float):
	
	if debug == false:
		var was_on_floor = is_on_floor()
		player_falling(delta)
		player_idle(delta)
		player_run(delta)
		player_jump(delta)
		player_shoot(delta)
		move_and_slide()
		player_animations()
		projectile_origin_position()
		player_death()
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
"		
		if direction < 0:
			ProjectileOrigin.position.x = -abs(muzzle_position.x)
		else:
			ProjectileOrigin.position.x = abs(muzzle_position.x)"

#testing

func player_jump(delta: float):
	var direction = input_movement()

	# Coyote and Double Jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = jump_velocity
		current_state = State.Jump
		#print("State: ", State.keys()[current_state]) # State Machine Debug

	# Allow horizontal control during jump
	if !is_on_floor() and current_state == State.Jump:
		velocity.x += direction * jump_horizontal * delta
		
func player_shoot(delta: float):
	var direction = input_movement()
	
	if  Input.is_action_just_pressed("shoot") and current_state != State.Shoot:
		var projectile_instance = projectile.instantiate() as Node2D
		projectile_instance.global_position = ProjectileOrigin.global_position
		#get_parent().add_child(projectile_instance)
		var world = get_tree().current_scene
		world.add_child(projectile_instance)
		
		projectile_instance.direction = direction
		
		if animated_sprite_2d.flip_h == false:

			projectile_instance.direction = direction + 1

		else:

			projectile_instance.direction = direction - 1
			
		current_state = State.Shoot
		print(ProjectileOrigin.position)
	
	
	
	#print("State: ", State.keys()[current_state]) #State Machine Debug
		
	
	
func player_melee(delta):
	var direction = input_movement()
	
	if Input.is_action_just_pressed("melee"):
		current_state = State.Melee
		print("pressing melee")
		
		
func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Run and (animated_sprite_2d.animation != "Shoot" || animated_sprite_2d.animation != "Melee"):
		animated_sprite_2d.play("Run")
	elif current_state == State.Jump:
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
	if health_amount <= 0:
		print("dead")
	



func projectile_origin_position():
	if animated_sprite_2d.flip_h:
		ProjectileOrigin.position.x = -abs(ProjectileOrigin.position.x)
	else:
		ProjectileOrigin.position.x = abs(ProjectileOrigin.position.x)

	
