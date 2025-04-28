extends Label

func _on_life_lost():
	text = "Lives: %s" % $"../../Player".lives
