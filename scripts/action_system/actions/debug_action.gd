extends Action
class_name DebugAction

func apply() -> void :
	DebugEffect.new("Debug Action").apply()
	RNGDebugEffect.new().apply()
