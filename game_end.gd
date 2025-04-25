extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass


func _on_quit_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	get_tree().quit()
	pass # Replace with function body.


func _on_restart_pressed() -> void: #I can't check this functionality until the player can die!!
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	get_tree().change_scene_to_file("res://control.tscn")  
	print("control called") 
	pass
