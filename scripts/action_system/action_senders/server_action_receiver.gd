extends ActionReceiver
class_name ServerActionReceiver

signal add_effect(effect : Effect)

func query_action(action : Action) -> void :
	for effect in action.get_effects() :
		add_effect.emit(effect)
