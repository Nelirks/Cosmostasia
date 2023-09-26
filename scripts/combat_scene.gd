extends Control

func _ready() -> void:
	ActionManager.send_message.connect(_on_action_manager_send_message)

func _on_action_button_pressed() -> void:
	ActionManager.query_action(DebugAction.new())


func _on_action_manager_send_message(message) -> void:
	($Console as RichTextLabel).text += message + "\n"
