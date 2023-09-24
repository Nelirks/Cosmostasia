extends RefCounted
class_name Effect

func apply() -> void :
	ActionManager.send_message.emit("Effect Result : " + str(ActionManager.random.randi_range(0, 100)))
