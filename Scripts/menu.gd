extends Node


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level.tscn")

func _process(delta):
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene_to_file("res://Scenes/level.tscn")
