extends CanvasLayer

@onready var pause_menu = get_node("HUD/PauseMenu")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu = get_node_or_null("PauseMenu")
	if pause_menu:
		pause_menu.hide()
	else:
		print("PauseMenu not found!")
	#This entire block still isnt working!! 
	if pause_menu:
		$PauseMenu/Music/MSlider.value = linear_to_db(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
		$PauseMenu/Sound/HSlider.value = linear_to_db(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundEffects")))
		$PauseMenu/Music/MSlider.connect("value_changed", Callable(self, "_on_MusicSlider_value_changed"))
		$PauseMenu/Sound/HSlider.connect("value_changed", Callable(self, "_on_SoundSlider2_value_changed"))
	else:
		pass # Replace with function body.

func _on_MusicSlider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, db_to_linear(value))

func _on_SoundSlider2_value_changed(value):
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, db_to_linear(value))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func _on_pause_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(.45).timeout
	get_tree().paused = true
	$PauseMenu.show()

func _on_back_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(.45).timeout
	get_tree().paused = false
	$PauseMenu.hide() #NOT WORKING??
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
