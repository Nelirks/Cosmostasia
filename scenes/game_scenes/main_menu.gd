extends Button

func _ready():
	AudioManager.post_event(AK.EVENTS.START_MUSIC)
	AudioManager.post_event(AK.EVENTS.START_MAINMENUMUSIC)

func _on_pressed():
	get_tree().change_scene_to_file("res://scenes/game_scenes/network_setup.tscn")
