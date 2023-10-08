extends Node

var rng : RandomNumberGenerator

signal synced_state(state : GameState)

enum GameState { NONE, COMBAT }
var _state : GameState
var _peer_state : GameState

enum Turn { NONE, HOST, CLIENT }
var _current_turn : Turn

var player : Player
var opponent : Player

signal send_message(message : String)

func _ready() -> void:
	NetworkManager.connection_done.connect(_on_network_connection)

func _init() :
	rng = RandomNumberGenerator.new()

func _on_network_connection() -> void :
	if (NetworkManager.is_host()) :
		_init_server_rng()

func _init_server_rng() -> void :
	if NetworkManager.is_multiplayer :
		_sync_client_rng.rpc(rng.seed, rng.state)

@rpc("authority", "call_remote", "reliable")
func _sync_client_rng(seed : int, state : int) -> void :
	rng.seed = seed
	rng.state = state

func set_game_state(state : GameState) -> void :
	_state = state
	if NetworkManager.is_multiplayer :
		_notify_game_state_change.rpc(state)
		if _state == _peer_state :
			synced_state.emit(state)
	else :
		synced_state.emit(state)

func set_random_game_turn() -> void :
	_current_turn = Turn.CLIENT if NetworkManager.is_multiplayer and rng.randi_range(0, 1) else Turn.HOST

func next_turn() -> void :
	if _current_turn == Turn.NONE : 
		push_error("CANNOT DO TO NEXT TURN IF CURRENT TURN IS NONE")
		return
	elif _current_turn == Turn.HOST :
		_current_turn = Turn.CLIENT
		if !NetworkManager.is_multiplayer : 
			next_turn()
	elif _current_turn == Turn.CLIENT : 
		_current_turn = Turn.HOST

func turn_is_none() -> bool :
	return _current_turn == Turn.NONE

func is_player_turn() -> bool :
	return !turn_is_none() and ((_current_turn == Turn.HOST) == player.is_host)

@rpc("any_peer", "call_remote", "reliable")
func _notify_game_state_change(state : GameState) -> void :
	_peer_state = state
	if _state == _peer_state :
		synced_state.emit(state)

func get_player(is_host : bool) -> Player:
	if is_host and NetworkManager.is_host() or !is_host and !NetworkManager.is_host() :
		return player
	else : 
		return opponent
