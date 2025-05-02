extends Area2D

var damage_amount : int = 1
var melee_impact_effect = preload("res://Player/Melee/melee_impact_effect.tscn")


func get_damage_amount():
	return damage_amount

func _on_hitbox_body_entered(body: Node2D) -> void:
	print("projectile body entered ")
	

func melee_impact(enemy: Node2D):
	var melee_impact_effect_instance = melee_impact_effect.instantiate() as Node2D
	melee_impact_effect_instance.global_position = enemy.global_position
	get_parent().add_child(melee_impact_effect_instance)



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.health_amount -= damage_amount

		
		if body.has_method("apply_knockback"):
			var direction = (body.global_position - global_position).normalized()
			body.apply_knockback(direction)
