extends Control
var config = ConfigFile.new()
var err = config.load("user://gameconfig.cfg")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FirstOpen.visible = true
	$Story.visible = false
	$Explainer.visible = false
	$GameLose.play()
	print("ready")

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


func _on_quit_button_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	get_tree().quit()
	pass # Replace with function body.


func _on_load_button_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	get_tree().change_scene_to_file("res://Levels/level.tscn")
	pass # Replace with function body.
	

func _on_play_2_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(0.45).timeout
	$FirstOpen.visible = false
	$Story.visible = false
	
	config.set_value("game_properties", "position", Vector2.ZERO)
	config.set_value("game_properties", "revealAbility", false)
	config.set_value("game_properties", "inCourtyard", false)
	config.save("user://gameconfig.cfg")
	
	get_tree().change_scene_to_file("res://Levels/level.tscn")


func _on_next_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	$FirstOpen.visible = false
	$Story.visible = false
	$Explainer.visible = true
	pass # Replace with function body.
