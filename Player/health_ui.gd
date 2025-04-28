extends HBoxContainer

@onready var heart1 = $Heart1
@onready var heart2 = $Heart2
@onready var heart3 = $Heart3
@onready var heart4 = $Heart4  
@onready var heart5 = $Heart5


func _ready() -> void:
	pass


func _on_player_life_lost(lives_left: int):
	match lives_left:
		4:
			heart5.hide()
		3:
			heart4.hide()
		2:
			heart3.hide()
		1:
			heart2.hide()
		0:
			heart1.hide()
			
func _on_player_life_gained(lives:int):
	match lives:
		5:
			heart5.show()
		4:
			heart4.show()
		3:
			heart3.show()
		2:
			heart2.show()
		1:
			heart1.show()
