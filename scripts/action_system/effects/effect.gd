extends RefCounted
class_name Effect

func apply() -> void :
	ActionManager.send_message.emit("Effect Applied")
