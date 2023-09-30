extends Node

var rng : RandomNumberGenerator

var player : Player
var opponent : Player

signal send_message(message : String)

func _init() :
	rng = RandomNumberGenerator.new()

func start_game() :
	player = Player.new(NetworkManager.is_host())
	opponent = Player.new(!NetworkManager.is_host())
	if (NetworkManager.is_host()) :
		_init_server_rng()

func _init_server_rng() -> void :
	if multiplayer.has_multiplayer_peer() :
		rng.randomize()
		_sync_client_rng.rpc(rng.seed, rng.state)

@rpc("authority", "call_remote", "reliable")
func _sync_client_rng(seed : int, state : int) -> void :
	rng.seed = seed
	rng.state = state

func query_action(action : Action) -> void :
	if multiplayer.is_server() :
		_apply_action(action)
		if multiplayer.has_multiplayer_peer() :
			_apply_action_from_str.rpc(var_to_str(action).replace("\n", ""))
	else :
		_query_action_from_str.rpc(var_to_str(action).replace("\n", ""))

@rpc("any_peer", "call_remote", "reliable")
func _query_action_from_str(action) -> void :
	query_action(str_to_var(action))

func _apply_action(action : Action) -> void :
	action.apply()

@rpc("authority", "call_remote", "reliable")
func _apply_action_from_str(action : String) -> void :
	_apply_action(str_to_var(action))

func get_player(is_host : bool) -> Player:
	if is_host and NetworkManager.is_host() or !is_host and !NetworkManager.is_host() :
		return player
	else : 
		return opponent

func get_character(selector : CharacterSelector) -> Character :
	return get_player(selector.player_is_host).get_character(selector.index)
