extends Effect
class_name RNGDebugEffect

func apply() -> void :
	GameManager.send_message.emit("Debug Effect : " + str(GameManager.rng.randi_range(0, 100)))
