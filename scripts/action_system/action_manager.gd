extends Node

var _action_sender : ActionSender
var _effect_applier : EffectApplier

signal send_message(message : String)

func _init() -> void :
	NetworkManager.connection_done.connect(_on_connection_done)

func _on_connection_done() -> void :
	_setup(multiplayer.is_server())
	pass

func _setup(is_server : bool) -> void :
	if is_server :
		_action_sender = ServerActionSender.new()
		(_action_sender as ServerActionSender).add_effect.connect(apply_effect)
		_effect_applier = ServerEffectApplier.new()
	else :
		_action_sender = ClientActionSender.new()
		_effect_applier = ClientEffectApplier.new()
	pass


func add_action(action : Action) -> void :
	_action_sender.add_action(action)

@rpc("any_peer", "call_remote")
func add_action_from_str(action) :
	add_action(str_to_var(action))

func apply_effect(effect : Effect) -> void :
	_effect_applier.apply_effect(effect)

@rpc("authority", "call_remote")
func apply_effect_from_str(effect : String) -> void:
	_effect_applier.apply_effect(str_to_var(effect))
