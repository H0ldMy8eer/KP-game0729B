extends Node2D

@onready var buttons = $Buttons



func _on_quit_pressed():
	buttons.play()
	await buttons.finished
	get_tree().quit()


func _on_play_pressed():
	buttons.play()
	await buttons.finished
	get_tree().change_scene_to_file("res://Location/lvl 1/level.tscn")


func _on_info_pressed():
	buttons.play()
	await buttons.finished
	get_tree().change_scene_to_file("res://menu_info.tscn")
