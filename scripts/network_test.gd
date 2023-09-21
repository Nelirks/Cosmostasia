extends Control

func _ready() -> void:
	NetworkManager.send_message.connect(_display_in_console)
	ActionManager.send_message.connect(_display_in_console)
	NetworkManager.connection_done.connect(_start_game)

func _on_join_button_pressed() -> void:
	NetworkManager.create_client("127.0.0.1", "8888")
	_disable_buttons()

func _on_host_button_pressed() -> void:
	NetworkManager.create_server("8888")
	_disable_buttons()

func _on_start_game_button_pressed() -> void:
	_start_game()

func _start_game() -> void:
	ActionManager.start_game()
	_disable_buttons()

func _disable_buttons() :
	($HostButton as Button).disabled = true
	($JoinButton as Button).disabled = true
	($StartGameButton as Button).disabled = true

func _display_in_console(message : String) -> void :
	($Console as RichTextLabel).text += message + "\n"

func _on_action_button_pressed() -> void:
	ActionManager.query_action(Action.new())
