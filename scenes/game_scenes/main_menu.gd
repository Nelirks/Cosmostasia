extends Control

func _on_host_button_pressed():
	pass # Replace with function body.

func _on_join_button_pressed():
	pass # Replace with function body.

func _on_texture_button_mouse_entered():
	%TextureButton.scale = Vector2(1.1, 1.1)


func _on_texture_button_mouse_exited():
	%TextureButton.scale = Vector2(1, 1)


func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game_scenes/settings_menu.tscn")


