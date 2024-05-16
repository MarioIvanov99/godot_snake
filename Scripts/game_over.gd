extends Node


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/level.tscn")


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _process(delta):
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene_to_file("res://Scenes/level.tscn")
