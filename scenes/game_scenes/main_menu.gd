extends Control

@export var wait_panel_fade_in_duration : float
var credits_scene = preload("res://scenes/game_scenes/credits_scene.tscn")

func _ready():
	NetworkManager.connection_done.connect(_start_game)
	
func _on_host_button_pressed():
	if OS.has_feature("solo") : _start_game()
	else : 
		NetworkManager.create_server((%PortEdit as TextEdit).text)
		%HostButton.visible = false
		%JoinButton.visible = false
		display_wait_panel()
	
func _on_join_button_pressed():
	if OS.has_feature("solo") : _start_game()
	else : 
		NetworkManager.create_client((%IPEdit as TextEdit).text, (%PortEdit as TextEdit).text)
		display_wait_panel()
		%JoinButton.visible = false
		%HostButton.visible = false

func _on_settings_button_pressed():
	%SettingsBackground.set_position(Vector2(0,0))

func _on_button_pressed():
	%SettingsBackground.set_position(Vector2(-2000,0))

func _start_game() -> void :
	GameManager.set_game_state(GameManager.GameState.DRAFT)


func display_wait_panel() -> void :
	$WaitPanel.visible = true
	$WaitPanel.self_modulate = Color(1, 1, 1, 0)
	var tween : Tween = create_tween()
	tween.tween_property($WaitPanel, "self_modulate", Color(1, 1, 1, 1), wait_panel_fade_in_duration)


func _on_credits_button_pressed():
	get_tree().change_scene_to_packed(credits_scene)
