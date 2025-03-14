extends CharacterBody2D

enum State {Idle,Walk}
var current_state : State
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var patrol_points = $PatrolPoints
@onready var timer: Timer = $Timer

@export var gravity = 1000
@export var speed = 3000.0
@export var jump_velocity = -400.0
#@export var patrol_points : Node

@export var patrol_wait_time : int = 3

@export var health_amount : int = 5
@export var damage_amount : int = 1

var direction : Vector2 = Vector2.LEFT
var number_of_points : int 
var point_positions : Array[Vector2]
var current_point: Vector2
var current_point_position : int
var can_walk : bool 



func _ready():
	timer.wait_time = patrol_wait_time		
	
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No patrol points")
		

	

func _physics_process(delta: float):
	enemy_gravity(delta)
	move_and_slide()
	enemy_idle(delta)
	enemy_walk(delta)
	enemy_animations()
	
	
func enemy_gravity(delta:float):
	velocity.y += gravity * delta


func enemy_idle(delta:float):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		current_state = State.Idle
	
	
func enemy_walk(delta:float):
	if !can_walk:
		return
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
	else:
		current_point_position += 1
		if current_point_position >= number_of_points:
			current_point_position = 0
			
		current_point = point_positions[current_point_position]
		
		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		
		can_walk = false
		timer.start()
	animated_sprite_2d.flip_h = direction.x > 0
	
	velocity.x = direction.x * speed * delta
	current_state = State.Walk
	
func enemy_animations():
	if current_state == State.Idle && !can_walk:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Walk && can_walk:
		animated_sprite_2d.play("Walk")

	
func _on_timer_timeout() -> void:
	can_walk = true
	#can_walk = !can_walk

func _on_hurt_box_area_entered(area: Area2D) -> void:
	print("Enemy Hurtbox Entered")
