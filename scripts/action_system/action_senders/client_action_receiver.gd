extends ActionReceiver
class_name ClientActionReceiver

func query_action(action : Action) -> void :
	ActionManager.query_action_from_str.rpc(var_to_str(action))
