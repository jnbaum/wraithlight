extends AnimatableBody2D

var falling = false
var hovering = false
var rising = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (falling):
		book_falling()
	if (hovering):
		book_hovering()
	if (rising):
		book_rising()

func book_falling():
	pass

func book_rising():
	pass

func book_hovering():
	pass

func _on_wait_timeout() -> void:
	pass # Replace with function body.

func _on_hover_timeout() -> void:
	pass # Replace with function body.
