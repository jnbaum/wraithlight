extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FirstOpen.visible = true
	$Story.visible = false
	$Explainer.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func _on_settings_button_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	#get_tree().change_scene_to_file("res://settings.tscn")
	pass # Replace with function body.
	

func _on_play_button_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	$FirstOpen.visible = false
	$Story.visible = true
	#get_tree().change_scene_to_file("res://FirstCut.tscn")


func _on_quit_button_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	get_tree().quit()
	pass # Replace with function body.


func _on_load_button_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	#PUT STUFF HERE
	pass # Replace with function body.
	

func _on_play_2_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(0.45).timeout
	$FirstOpen.visible = false
	$Story.visible = false
	get_tree().change_scene_to_file("res://Levels/level.tscn")
	pass # Replace with function body.


func _on_next_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	$FirstOpen.visible = false
	$Story.visible = false
	$Explainer.visible = true
	pass # Replace with function body.
