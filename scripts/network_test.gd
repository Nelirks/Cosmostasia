extends Control

func _ready() -> void:
	NetworkManager.send_message.connect(_display_in_console)
	ActionManager.send_message.connect(_display_in_console)

func _on_join_button_pressed() -> void:
	NetworkManager.create_client("127.0.0.1", "8888")

func _on_host_button_pressed() -> void:
	NetworkManager.create_server("8888")

func _display_in_console(message : String) -> void :
	($Console as RichTextLabel).text += message + "\n"

func _on_action_button_pressed() -> void:
	ActionManager.add_action(Action.new())
