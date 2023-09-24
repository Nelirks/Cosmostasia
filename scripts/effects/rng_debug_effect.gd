extends Effect
class_name RNGDebugEffect

func apply() -> void :
	ActionManager.send_message.emit("Debug Effect : " + str(ActionManager.random.randi_range(0, 100)))
