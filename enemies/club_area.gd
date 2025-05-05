extends Area2D

@onready var ogre = $".."
var damage_amount : int = 1

func _ready():
	pass


func get_damage_amount() -> int:
		return damage_amount


func _on_hit_timer_timeout() -> void:
	print("clubbing")
	deal_damage()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		ogre.is_attacking = true
		$HitTimer.start()
	print(area,"enetred erea")





func _on_club_area_area_exited(area: Area2D) -> void:
	ogre.is_attacking = false
	$HitTimer.stop()
	print("player left")
	
func deal_damage():
		Global.Player.lose_life(damage_amount)
		print(Global.Player.lives)
