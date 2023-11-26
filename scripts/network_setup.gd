extends Control

func _ready() -> void:
	NetworkManager.send_message.connect(_display_in_console)
	GameManager.send_message.connect(_display_in_console)
	NetworkManager.connection_done.connect(_start_game)

func _on_join_button_pressed() -> void:
	NetworkManager.create_client(($IPEdit as TextEdit).text, ($PortEdit as TextEdit).text)
	_disable_buttons()

func _on_host_button_pressed() -> void:
	NetworkManager.create_server(($PortEdit as TextEdit).text)
	_disable_buttons()

func _start_game() -> void:
	_disable_buttons()
	GameManager.set_game_state(GameManager.GameState.COMBAT)

func _disable_buttons() :
	($HostButton as Button).disabled = true
	($JoinButton as Button).disabled = true
	($SoloButton as Button).disabled = true

func _display_in_console(message : String) -> void :
	($Console as RichTextLabel).text += message + "\n"

func _on_solo_button_pressed() -> void:
	_start_game()
