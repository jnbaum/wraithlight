extends HBoxContainer

@onready var flame1 = $Flame1
@onready var flame2 = $Flame2
@onready var flame3 = $Flame3
@onready var flame4 = $Flame4
@onready var flame5 = $Flame5

func _on_shot_fired(shots_left: int):
	match shots_left:
		4:
			flame5.hide()
		3:
			flame4.hide()
		2:
			flame3.hide()
		1:
			flame2.hide()
		0:
			flame1.hide()

func _on_shot_gained(shots: int):
	match shots:
		5:
			flame5.show()
		4:
			flame4.show()
		3:
			flame3.show()
		2:
			flame2.show()
		1:
			flame1.show()
