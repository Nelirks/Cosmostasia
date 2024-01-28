extends Control

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game_scenes/network_setup.tscn")


func _on_texture_button_mouse_entered():
	%TextureButton.scale = Vector2(1.1, 1.1)


func _on_texture_button_mouse_exited():
	%TextureButton.scale = Vector2(1, 1)
