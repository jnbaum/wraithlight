extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Music/MusicSlider.value = linear_to_db(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$Sound/SoundSlider2.value = linear_to_db(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundEffects")))
	$Music/MusicSlider.connect("value_changed", Callable(self, "_on_MusicSlider_value_changed"))
	$Sound/SoundSlider2.connect("value_changed", Callable(self, "_on_SoundSlider2_value_changed"))

	pass # Replace with function body.

func _on_MusicSlider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, db_to_linear(value))

func _on_SoundSlider2_value_changed(value):
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, db_to_linear(value))
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_button_pressed() -> void: #BACK BUTTON
	
	pass # Replace with function body.
	



func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
	



func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level.tscn")
	pass # Replace with function body.
