extends Label
signal earned_bonus_life
var score = 0
var points_for_life = 50
var life_earned_at = 0


func _on_Mob_squashed():
	score += 1
	text = "Score: %s" % score
	
	if score >= points_for_life:
		earned_bonus_life.emit()
		life_earned_at = score
