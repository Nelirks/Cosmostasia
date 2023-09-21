extends Node

const _server_action_receiver_scene : PackedScene = preload("res://scenes/action_system/server_action_receiver.tscn")
const _client_action_receiver_scene : PackedScene = preload("res://scenes/action_system/client_action_receiver.tscn")
const _server_effect_applier_scene : PackedScene = preload("res://scenes/action_system/server_effect_applier.tscn")
const _client_effect_applier_scene : PackedScene = preload("res://scenes/action_system/client_effect_applier.tscn")

var _action_receiver : ActionReceiver
var _effect_applier : EffectApplier

signal send_message(message : String)

func start_game() -> void:
	if (not multiplayer.has_multiplayer_peer()) or multiplayer.is_server() :
		_action_receiver = _server_action_receiver_scene.instantiate()
		(_action_receiver as ServerActionReceiver).add_effect.connect(apply_effect)
		_effect_applier = _server_effect_applier_scene.instantiate()
	else :
		_action_receiver = _client_action_receiver_scene.instantiate()
		_effect_applier = _client_effect_applier_scene.instantiate()
	add_child(_action_receiver)
	add_child(_effect_applier)

func query_action(action : Action) -> void :
	_action_receiver.query_action(action)

@rpc("any_peer", "call_remote")
func query_action_from_str(action) :
	query_action(str_to_var(action))

func apply_effect(effect : Effect) -> void :
	_effect_applier.apply_effect(effect)

@rpc("authority", "call_remote")
func apply_effect_from_str(effect : String) -> void:
	_effect_applier.apply_effect(str_to_var(effect))
