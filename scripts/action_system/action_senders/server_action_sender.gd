extends ActionSender
class_name ServerActionSender

signal add_effect(effect : Effect)

func add_action(action : Action) -> void :
	for effect in action.get_effects() :
		add_effect.emit(effect)
