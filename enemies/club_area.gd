extends Area2D

@onready var ogre = $".."
var damage_amount : int = 1



func get_damage_amount() -> int:
		return damage_amount




func _on_body_entered(body: Node2D) -> void:
	print("hey")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$HitTimer.stop


func _on_hit_timer_timeout() -> void:
	print("clubbing")
	#deal_damage()


#func club_attack():


func _on_area_entered(area: Area2D) -> void:
	ogre.is_attacking = true
	
	var player = area.get_parent()
	print("club area entered")
	





func _on_club_area_area_exited(area: Area2D) -> void:
	ogre.is_attacking = false
	print("player left")


func get_player_health(body: Node2D) -> int:
	return body.health
	
	
	
