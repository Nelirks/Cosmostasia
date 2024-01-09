extends Button

func _on_pressed():
	get_tree().change_scene_to_file("res://scenes/game_scenes/network_setup.tscn")
