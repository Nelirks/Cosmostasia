extends ActionSender
class_name ClientActionSender

func add_action(action : Action) -> void :
	ActionManager.add_action_from_str.rpc(var_to_str(action))
