extends Node2D
var save_path = "game_state.save"
var playerPosition
var player : CharacterBody2D

var volume = {}
var config = ConfigFile.new()
var err = config.load("user://gameconfig.cfg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if err != OK:
		pass
		
	else:
		print(config.get_value("game_properties", "inCourtyard"))
		$Player.position = config.get_value("game_properties", "position")
		if config.get_value("game_properties", "revealAbility") == true:
			$Collectables/RevealPowerup.hide()
		
		if config.get_value("game_properties", "inCourtyard") == false:
			$ParallaxBackground/ParallaxLayer2/Courtyard.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	playerPosition = $Player.update_position()

func save():
	
	if playerPosition == null:
		pass
	else:
		config.set_value("game_properties", "position", playerPosition)
		config.set_value("game_properties", "revealAbility", $Player.get_reveal())
		config.set_value("game_properties", "inCourtyard", $ParallaxBackground/ParallaxLayer2/Courtyard.is_visible_in_tree())
		config.save("user://gameconfig.cfg")

func _on_save_fire_body_entered(body: Node2D) -> void:
	$FireWoosh.play() #Why isn't this working???
	print("done")
	save()
	
	

func _on_hide_courtyard_body_entered(body: Node2D) -> void:
	$ParallaxBackground/ParallaxLayer2/Courtyard.hide()

func _on_show_couryard_body_entered(body: Node2D) -> void:
	$ParallaxBackground/ParallaxLayer2/Courtyard.show()

func _unhandled_input(event):
	if event.is_action_pressed("clear_save"):
		config.set_value("game_properties", "position", Vector2.ZERO)
		config.set_value("game_properties", "revealAbility", false)
		config.set_value("game_properties", "inCourtyard", false)
		config.save("user://gameconfig.cfg")

func _on_reveal_powerup_body_entered(body: Node2D) -> void:
	$Collectables/RevealPowerup.hide()
	$Player.set_reveal(true)
