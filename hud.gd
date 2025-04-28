extends CanvasLayer

@onready var pause_menu = get_node("HUD/PauseMenu")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Debug here to try to see why I can't call Pause Menu??
	pause_menu = $HUD/PauseMenu
	if pause_menu:
		pause_menu.visible = false
	else:
		print("PauseMenu is not found")
	
	#This entire block isnt working!! I need to figure out why I cannot access PauseMenu first, then this may be operational.
	
	#pause_menu.visible = false
	#$PauseMenu/Music/MSlider.value = linear_to_db(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	#$PauseMenu/Sound/HSlider.value = linear_to_db(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundEffects")))
	#$PauseMenu/Music/MSlider.connect("value_changed", Callable(self, "_on_MusicSlider_value_changed"))
	#$PauseMenu/Sound/Hslider.connect("value_changed", Callable(self, "_on_SoundSlider2_value_changed"))
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
	await get_tree().create_timer(1.25).timeout
	get_tree().paused = true
	pause_menu.visible = true

func _on_back_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	pause_menu.visible = false #NOT WORKING??
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
