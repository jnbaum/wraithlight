extends Node2D
var save_path = "game_state.save"
var playerPosition
var posx
var posy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ParallaxBackground/ParallaxLayer2/Courtyard.hide()
	load_data()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	playerPosition = $Player.update_position()
	posx = playerPosition.x
	posy = playerPosition.y

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(posx)
	file.store_var(posy)
	
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var(true)
		$Player.load_position(file.get_var(true))
	else:
		pass

func _on_save_fire_body_entered(body: Node2D) -> void:
	print("done")
	save()

func _on_hide_courtyard_body_entered(body: Node2D) -> void:
	$ParallaxBackground/ParallaxLayer2/Courtyard.hide()

func _on_show_couryard_body_entered(body: Node2D) -> void:
	$ParallaxBackground/ParallaxLayer2/Courtyard.show()
