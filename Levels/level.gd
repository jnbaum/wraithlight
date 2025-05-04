extends Node2D
var save_path = "game_state.save"
var playerPosition


var volume = {}
var config = ConfigFile.new()
var err = config.load("user://gameconfig.cfg")

var skyIsMovedUp = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if err != OK:
		pass
		
	else:
		$Player.position = config.get_value("game_properties", "position")
		if config.get_value("game_properties", "revealAbility") == true:
			$Collectables/RevealPowerup.hide()
			$PreReveal.hide()
		
		if config.get_value("game_properties", "inCourtyard") == false:
			$ParallaxBackground/ParallaxLayer2/Courtyard.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	playerPosition = $Player.update_position()

func save():
	
	if playerPosition == null:
		pass
	else:
		config.set_value("game_properties", "position", playerPosition)
		config.set_value("game_properties", "revealAbility", $Player.get_reveal())
		config.set_value("game_properties", "inCourtyard", $ParallaxBackground/ParallaxLayer2/Courtyard.is_visible_in_tree())
		config.save("user://gameconfig.cfg")
	
	$HUD/SaveMessage.show()
	
	await get_tree().create_timer(4).timeout
	
	$HUD/SaveMessage.hide()

func _on_save_fire_body_entered(_body: Node2D) -> void:
	$FireWoosh.play() 
	save()

func _on_hide_courtyard_body_entered(_body: Node2D) -> void:
	$ParallaxBackground/ParallaxLayer2/Courtyard.hide()

func _on_show_couryard_body_entered(_body: Node2D) -> void:
	$ParallaxBackground/ParallaxLayer2/Courtyard.show()


func _unhandled_input(event):
	if event.is_action_pressed("clear_save"):
		config.set_value("game_properties", "position", Vector2.ZERO)
		config.set_value("game_properties", "revealAbility", false)
		config.set_value("game_properties", "inCourtyard", false)
		config.save("user://gameconfig.cfg")

func _on_reveal_powerup_body_entered(_body: Node2D) -> void:
	$Collectables/RevealPowerup.hide()
	$Player.set_reveal(true)
	$PreReveal.queue_free()
	await get_tree().create_timer(1.5).timeout
	$HUD/LibraryMessage.show()
	
	await get_tree().create_timer(8).timeout
	
	$HUD/LibraryMessage.hide()


func _on_player_death(_body: Node2D) -> void: #this needs to be play tested! It may need tweaking.
	#clear or pause enemies here
	$GameOverSound.play() #Plays the player death sound (CURRENTLY NOT WORKING)
	$Player/AnimatedSprite2D.play("Dead") #THIS IS NOT WORKING
	await get_tree().create_timer(1.25).timeout #Small delay so that the sound has time to play
	get_tree().change_scene_to_file("res://GameEnd.tscn")  #Changes to the game over scene
	pass
	


func _on_debug_pressed() -> void: #This entire function is here to play test the character death. Delete after enemies are inserted and the player can actually die.
	print("debug pressed")
	$GameOverSound.play() #THIS LINE NOT WORKING
	$Player/AnimatedSprite2D.play("Dead") #THIS LINE NOT WORKING?????
	await get_tree().create_timer(1.25).timeout
	get_tree().change_scene_to_file("res://GameEnd.tscn")  
	pass # Replace with function body.


func _on_move_sky_up_body_entered(body: Node2D) -> void:
	if skyIsMovedUp == false:
		$ParallaxBackground/ParallaxLayer/Sky.move_local_y(-50)
		skyIsMovedUp = true


func _on_move_sky_down_body_entered(body: Node2D) -> void:
	if skyIsMovedUp == true:
		$ParallaxBackground/ParallaxLayer/Sky.move_local_y(50)
		skyIsMovedUp = false


func _on_fall_area_1_body_entered(body: Node2D) -> void:
	$Player.position = Vector2(3873, -5647)

func _on_fall_area_2_body_entered(body: Node2D) -> void:
	$Player.position = Vector2(5220, -5494)

func _on_fall_area_3_body_entered(body: Node2D) -> void:
	$Player.position = Vector2(3222, -6289)
