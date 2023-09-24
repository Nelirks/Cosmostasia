extends Effect
class_name DebugEffect

func apply() -> void :
	ActionManager.send_message.emit("Debug Effect Applied")
