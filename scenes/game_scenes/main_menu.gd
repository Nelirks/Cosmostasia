extends Control

func _on_host_button_pressed():
	NetworkManager.create_server((%PortEdit as TextEdit).text)

func _on_join_button_pressed():
	NetworkManager.create_client((%IPEdit as TextEdit).text, (%PortEdit as TextEdit).text)

func _on_settings_button_pressed():
	%SettingsBackground.set_position(Vector2(0,0))

func _on_button_pressed():
	%SettingsBackground.set_position(Vector2(-2000,0))
