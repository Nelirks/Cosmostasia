extends Node

signal send_message(message : String)

var random : RandomNumberGenerator

func _init() :
	random = RandomNumberGenerator.new()

func _ready() -> void:
	NetworkManager.connection_done.connect(_on_connection_done)

func _on_connection_done() -> void:
	if multiplayer.is_server() :
		_init_random_server()

func _init_random_server() -> void :
	if multiplayer.has_multiplayer_peer() and multiplayer.is_server() :
		_init_random_client.rpc(random.seed, random.state)

@rpc("authority", "call_remote", "reliable")
func _init_random_client(seed : int, state : int) -> void :
	random.seed = seed
	random.state = state

func query_action(action : Action) -> void :
	if multiplayer.is_server() :
		_apply_action(action)
		if multiplayer.has_multiplayer_peer() :
			_apply_action_from_str.rpc(var_to_str(action))
	else :
		_query_action_from_str.rpc(var_to_str(action))

@rpc("any_peer", "call_remote", "reliable")
func _query_action_from_str(action) -> void :
	query_action(str_to_var(action))

func _apply_action(action : Action) -> void :
	action.apply()

@rpc("authority", "call_remote", "reliable")
func _apply_action_from_str(action : String) -> void :
	_apply_action(str_to_var(action))
