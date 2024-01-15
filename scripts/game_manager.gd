extends Node

var rng : RandomNumberGenerator

var _draft_scene : PackedScene = preload("res://scenes/draft_phase/draft_scene.tscn")
var _deckbuilding_scene : PackedScene = preload("res://scenes/deckbuilding_phase/deckbuilding_scene.tscn")
var _combat_scene : PackedScene = preload("res://scenes/game_scenes/final_combat_board.tscn")
var _end_screen_scene : PackedScene = preload("res://scenes/game_scenes/end_screen.tscn")
@onready var combat : CombatManager = $CombatManager

enum GameState { NONE, DRAFT, DECKBUILDING, COMBAT, GAME_END }
var _state : GameState
var _peer_state : GameState

var player : Player:
	set(value):
		player = value
		player_set.emit()
var opponent : Player

signal send_message(message : String)
signal player_set()

func _ready() -> void:
	NetworkManager.connection_done.connect(_on_network_connection)

func _init() :
	rng = RandomNumberGenerator.new()

func _on_network_connection() -> void :
	pass

func sync_rng() -> void :
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
			_on_state_synced(state)
	else :
		_on_state_synced(state)

@rpc("any_peer", "call_remote", "reliable")
func _notify_game_state_change(state : GameState) -> void :
	_peer_state = state
	if _state == _peer_state :
		_on_state_synced(state)

func _on_state_synced(state : GameState) -> void :
	match state :
		GameState.NONE :
			pass
		GameState.DRAFT :
			if NetworkManager.is_host :
				sync_rng()
			player = Player.new(NetworkManager.is_host)
			opponent = Player.new(not NetworkManager.is_host)
			get_tree().change_scene_to_packed(_draft_scene)
		GameState.DECKBUILDING : 
			if NetworkManager.is_host :
				sync_rng()
			get_tree().change_scene_to_packed(_deckbuilding_scene)
		GameState.COMBAT :
			get_tree().change_scene_to_packed(_combat_scene)
			if NetworkManager.is_host : 
				sync_rng()
				combat.start_game.rpc()
		GameState.GAME_END : 
			get_tree().change_scene_to_packed(_end_screen_scene)

func get_player(is_host : bool) -> Player:
	if is_host and NetworkManager.is_host or !is_host and !NetworkManager.is_host :
		return player
	else : 
		return opponent
