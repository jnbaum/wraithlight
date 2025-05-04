extends AnimatedSprite2D
var projectile_impact_effect = preload("res://Player/projectile/projectile_impact_effect.tscn")

var speed = 600.0
var direction : int
var damage_amount : int = 1


func _physics_process(delta: float) -> void:
	move_local_x(direction * speed * delta)

func _on_timer_timeout() -> void:
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	#print("projectile body entered ")
	projectile_impact()

func get_damage_amount() -> int:
	return damage_amount
	
	
func projectile_impact():
	var projectile_impact_effect_instance = projectile_impact_effect.instantiate() as Node2D
	projectile_impact_effect_instance.global_position = global_position/3
	get_parent().add_child(projectile_impact_effect_instance)
	queue_free()
