extends Node2D


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Menu.tscn")
	
	


func _on_label_2_draw():
	pass # Replace with function body.
