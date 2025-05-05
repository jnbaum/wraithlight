extends Node2D
const level = preload("res://Levels/level.tscn")
const title = preload("res://Levels/control.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameLose.play()

func _on_quit_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	get_tree().change_scene_to_file("res://Levels/control.tscn")


func _on_restart_pressed() -> void:
	$ClickSound.play()
	await get_tree().create_timer(1.25).timeout
	get_tree().change_scene_to_packed(level)
