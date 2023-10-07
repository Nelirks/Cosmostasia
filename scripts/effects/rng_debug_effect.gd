extends Effect
class_name RNGDebugEffect

func apply(source : Character, target : Character) -> void :
	GameManager.send_message.emit("Debug Effect : " + str(GameManager.rng.randi_range(0, 100)))
