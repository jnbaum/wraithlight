extends Area2D

var damage_amount : int = 1



func get_damage_amount() -> int:
		return damage_amount




func _on_body_entered(body: Node2D) -> void:
	pass

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$HitTimer.stop


func _on_hit_timer_timeout() -> void:
	print("clubbing")
	#deal_damage()





func _on_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	
	





func _on_club_area_area_exited(area: Area2D) -> void:
	pass # Replace with function body.


func get_player_health(body: Node2D) -> int:
	return body.health
	
	
	
