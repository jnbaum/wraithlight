extends Node2D
@export var fade_duration: float = 2.0  # Time in seconds for the fade to complete

func _ready():
	pass





func _on_button_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	get_tree().change_scene_to_file("res://Levels/level.tscn")
	pass # Replace with function body.
