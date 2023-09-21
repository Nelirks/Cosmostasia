extends Node

const _server_action_sender : PackedScene = preload("res://scenes/action_system/server_action_sender.tscn")
const _client_action_sender : PackedScene = preload("res://scenes/action_system/client_action_sender.tscn")
const _server_effect_applier : PackedScene = preload("res://scenes/action_system/server_effect_applier.tscn")
const _client_effect_applier : PackedScene = preload("res://scenes/action_system/client_effect_applier.tscn")

var _action_sender : ActionSender
var _effect_applier : EffectApplier

signal send_message(message : String)

func start_game() -> void:
	if (not multiplayer.has_multiplayer_peer()) or multiplayer.is_server() :
		_action_sender = _server_action_sender.instantiate()
		(_action_sender as ServerActionSender).add_effect.connect(apply_effect)
		_effect_applier = _server_effect_applier.instantiate()
	else :
		_action_sender = _client_action_sender.instantiate()
		_effect_applier = _client_effect_applier.instantiate()
	add_child(_action_sender)
	add_child(_effect_applier)

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
