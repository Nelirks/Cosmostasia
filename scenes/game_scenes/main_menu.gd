extends Control

func _ready():
	NetworkManager.connection_done.connect(_start_game)
	%WaitingBackground.visible = false
	
func _on_host_button_pressed():
	if OS.has_feature("solo") : _start_game()
	else : NetworkManager.create_server((%PortEdit as TextEdit).text)
	%WaitingBackground.visible = true
	
func _on_join_button_pressed():
	if OS.has_feature("solo") : _start_game()
	else : NetworkManager.create_client((%IPEdit as TextEdit).text, (%PortEdit as TextEdit).text)

func _on_settings_button_pressed():
	%SettingsBackground.set_position(Vector2(0,0))

func _on_button_pressed():
	%SettingsBackground.set_position(Vector2(-2000,0))

func _start_game() -> void :
	GameManager.set_game_state(GameManager.GameState.DRAFT)

func _on_host_button_button_down():
	%HostButton.scale = Vector2(0.9, 0.9)


func _on_host_button_button_up():
	%HostButton.scale = Vector2(1, 1)

func _on_join_button_button_down():
	%JoinButton.scale = Vector2(0.9, 0.9)

func _on_join_button_button_up():
	%JoinButton.scale = Vector2(1, 1)

func _on_settings_button_button_down():
	$SettingsButton.scale = Vector2(0.9, 0.9)

func _on_settings_button_button_up():
	$SettingsButton.scale = Vector2(1, 1)
