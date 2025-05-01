extends CharacterBody2D

class_name OgreEnemy

const speed = 100
var is_enemy_chase : bool = false

var health_amount = 8
var health_max = 80
var health_min = 0

var dead: bool = false
var taking_damage: bool = false
var damage_amount = 2
var is_attacking: bool = false

var dir : Vector2
const gravity = 900
var knockback_force = -20
var is_roaming: bool = true
var player : CharacterBody2D

var enemy_death_effect = preload("res://enemies/enemy_death_effect.tscn")
@onready var club_area = $ClubArea
@onready var hit_timer = $ClubArea/HitTimer


func _process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
		
		player = Global.playerBody
	move(delta)
	handle_animation()
	move_and_slide()
	
func move(delta):
	if !dead:
		if !is_enemy_chase:
			velocity += dir * speed * delta
		elif is_enemy_chase and !taking_damage:
			var dir_to_player = position.direction_to(Global.Player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = abs(velocity.x) / velocity.x
			
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * knockback_force
			velocity.x = knockback_dir.x
		is_roaming = true
	elif dead:
		velocity.x = 0
		
func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if dir.x == -1:
		anim_sprite.flip_h = true
	elif dir.x == 1:
		anim_sprite.flip_h = false

	if !dead and !taking_damage and !is_attacking:
		anim_sprite.play("walk")
		
			
	elif !dead and taking_damage and !is_attacking:
		anim_sprite.play("hurt")
		await get_tree().create_timer(.8).timeout
		taking_damage = false
		
	elif dead and is_roaming:
		is_roaming = false
		await get_tree().create_timer(1.0).timeout
		handle_death()
		
	elif !dead and !taking_damage and is_attacking:
		anim_sprite.play("attack")

	
func handle_death():
	var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
	enemy_death_effect_instance.global_position = global_position
	get_parent().add_child(enemy_death_effect_instance)
	queue_free()
	

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5,2.0,2.5])
	
	if !is_enemy_chase:
		dir = choose([Vector2.RIGHT,Vector2.LEFT])
		velocity.x = 0
	
func choose(array):
	array.shuffle()
	return array.front()


func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount
		print("enemy health remaining: ", health_amount)
		
		if health_amount <= 0:
			var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
			enemy_death_effect_instance.global_position = global_position
			get_parent().add_child(enemy_death_effect_instance)
			queue_free()

func _on_aggro_range_area_entered(area: Area2D) -> void:
	is_enemy_chase = true
