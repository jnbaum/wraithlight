extends CanvasLayer

@onready var pause_menu #= get_node("HUD/PauseMenu")
@onready var hslider #= get_node("HUD/PauseMenu/Sound/Hslider")
@onready var mslider #= get_node("HUD/PauseMenu/Sound/Mslider")
signal quit

func _ready() -> void:
	pause_menu = get_node_or_null("PauseMenu")
	hslider = get_node_or_null("PauseMenu/Sound/HSlider")
	mslider = get_node_or_null("PauseMenu/Music/MSlider")
	
	if pause_menu:
		pause_menu.hide()
	else:
		print("PauseMenu not found!")
		
	#This entire block still isnt working!! No errors though. Idk. 
	if pause_menu:
		print("pause_menu working") #working
		mslider.value = linear_to_db(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
		hslider.value = linear_to_db(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundEffects")))
		mslider.connect("value_changed", Callable(self, "_on_MSlider_value_changed"))
		hslider.connect("value_changed", Callable(self, "_on_HSlider_value_changed"))
	else:
		pass # Replace with function body.

func _on_MSlider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, value)
	print("MSlider value changed")
	
func _on_HSlider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("SoundEffects")
	AudioServer.set_bus_volume_db(bus_index, value)
	print("HSlider value changed")
	
func _process(_delta: float) -> void: #EMPTY 
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
	$PauseMenu.hide()

func _on_quit_pressed() -> void:
	print("QUIT")
	quit.emit()
