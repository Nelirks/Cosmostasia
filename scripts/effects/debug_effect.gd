extends Effect
class_name DebugEffect

var message : String

func _init(message : String) :
	self.message = message

func apply() -> void :
	GameManager.send_message.emit(message)
