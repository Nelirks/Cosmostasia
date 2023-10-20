extends Node

var rng : RandomNumberGenerator
@onready var _end_screen_scene : PackedScene = preload("res://scenes/game_scenes/end_screen.tscn")
@onready var combat : CombatManager = $CombatManager

enum GameState { NONE, COMBAT, GAME_END }
var _state : GameState
var _peer_state : GameState

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
	if (_state == state) : 
		push_error("Cannot set the game state to the current one")
		return
	_state = state
	if NetworkManager.is_multiplayer :
		_notify_game_state_change.rpc(state)
		if _state == _peer_state :
			on_state_synced(state)
	else :
		on_state_synced(state)

@rpc("any_peer", "call_remote", "reliable")
func _notify_game_state_change(state : GameState) -> void :
	_peer_state = state
	if _state == _peer_state :
		on_state_synced(state)

func on_state_synced(state : GameState) -> void :
	match state :
		GameState.NONE :
			pass
		GameState.COMBAT :
			combat.start_game()
		GameState.GAME_END : 
			get_tree().change_scene_to_packed(_end_screen_scene)

func get_player(is_host : bool) -> Player:
	if is_host and NetworkManager.is_host() or !is_host and !NetworkManager.is_host() :
		return player
	else : 
		return opponent
