extends Control

func _ready():
	NetworkManager.connection_done.connect(_start_game)
	
func _on_host_button_pressed():
	NetworkManager.create_server((%PortEdit as TextEdit).text)

func _on_join_button_pressed():
	NetworkManager.create_client((%IPEdit as TextEdit).text, (%PortEdit as TextEdit).text)

func _on_settings_button_pressed():
	%SettingsBackground.set_position(Vector2(0,0))

func _on_button_pressed():
	%SettingsBackground.set_position(Vector2(-2000,0))
	
func _start_game() -> void:
	_disable_buttons()
	GameManager.set_game_state(GameManager.GameState.DRAFT)
	
func _disable_buttons() :
	(%HostButton as TextureButton).disabled = true
	(%JoinButton as TextureButton).disabled = true
