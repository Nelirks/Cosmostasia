extends Node

var rng : RandomNumberGenerator

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
	if multiplayer.has_multiplayer_peer() :
		rng.randomize()
		_sync_client_rng.rpc(rng.seed, rng.state)

@rpc("authority", "call_remote", "reliable")
func _sync_client_rng(seed : int, state : int) -> void :
	rng.seed = seed
	rng.state = state

@rpc("authority", "call_local", "reliable")
func start_game() :
	player = Player.new(NetworkManager.is_host())
	opponent = Player.new(!NetworkManager.is_host())
	get_player(true).shuffle_draw_pile()
	get_player(true).refill_hand()
	get_player(false).shuffle_draw_pile()
	get_player(false).refill_hand()
	print(get_player(true).get_card_in_hand(0).card_name)

@rpc("any_peer", "call_remote", "reliable")
func query_card_play(card_is_host : bool, card_index : int, target_is_host : bool, target_index : int) -> void :
	#Apply checks
	if NetworkManager.is_host() :
		_apply_card_play.rpc(card_is_host, card_index, target_is_host, target_index)
	else :
		query_card_play.rpc(card_is_host, card_index, target_is_host, target_index)

@rpc("authority", "call_local", "reliable")
func _apply_card_play(card_is_host : bool, card_index : int, target_is_host : bool, target_index : int) -> void :
	get_player(card_is_host).play_card(card_index, get_player(target_is_host).get_character(target_index))

func get_player(is_host : bool) -> Player:
	if is_host and NetworkManager.is_host() or !is_host and !NetworkManager.is_host() :
		return player
	else : 
		return opponent
