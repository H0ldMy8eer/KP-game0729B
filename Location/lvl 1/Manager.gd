extends Node

@onready var pause_menu = $"../CanvasLayer/PauseMenu"
@onready var unpause = $Unpause
@onready var pause = $Pause


var game_paused: bool = false
var save_path = "user://savegame.save"
@onready var character = $"../Player/Character"


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if game_paused == false:
			pause.play()
			
		elif game_paused == true:
			unpause.play()
			
		game_paused = !game_paused
		
	if game_paused == true:
		get_tree().paused = true
		pause_menu.show()
	else:
		get_tree().paused = false
		pause_menu.hide()


func _on_resume_pressed():
	unpause.play()
	game_paused = !game_paused


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu.tscn")
	
	
func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(Globall.gold)
	file.store_var(character.position.x)
	file.store_var(character.position.y)
	game_paused = !game_paused
	
	
func load_game():
	var file = FileAccess.open(save_path, FileAccess.READ)
	Globall.gold = file.get_var(Globall.gold)
	character.position.x = file.get_var(character.position.x)
	character.position.y = file.get_var(character.position.y)
	game_paused = !game_paused


func _on_save_pressed():
	save_game()


func _on_load_pressed():
	load_game()
