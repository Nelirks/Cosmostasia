extends Action
class_name DebugAction

func apply() -> void :
	DebugEffect.new().apply()
	RNGDebugEffect.new().apply()
