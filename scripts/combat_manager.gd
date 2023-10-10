extends Node
class_name CombatManager

enum Turn { NONE, HOST, CLIENT }
var _current_turn : Turn :
	set (value) :
		_current_turn = value
		if _current_turn != Turn.NONE :
			GameManager.get_player(true).on_turn_start(_current_turn == Turn.HOST)
			GameManager.get_player(false).on_turn_start(_current_turn == Turn.CLIENT)

var effect_stack : Array[Effect]

@rpc("authority", "call_local", "reliable")
func start_game() :
	GameManager.player = Player.new(NetworkManager.is_host())
	GameManager.opponent = Player.new(!NetworkManager.is_host())
	GameManager.get_player(true).shuffle_draw_pile()
	GameManager.get_player(true).refill_hand()
	GameManager.get_player(false).shuffle_draw_pile()
	GameManager.get_player(false).refill_hand()
	_set_random_game_turn()

@rpc("any_peer", "call_remote", "reliable")
func query_card_play(card_is_host : bool, card_index : int, target_is_host : bool, target_index : int) -> void :
	if !GameManager.get_player(card_is_host).can_play_card(card_index) : return
	if NetworkManager.is_host() :
		_apply_card_play.rpc(card_is_host, card_index, target_is_host, target_index)
	else :
		query_card_play.rpc(card_is_host, card_index, target_is_host, target_index)

@rpc("any_peer", "call_remote", "reliable")
func query_end_turn() -> void :
	if NetworkManager.is_host() :
		if !turn_is_none() and ((multiplayer.get_remote_sender_id() == 0) == is_player_turn()) :
			_apply_end_turn.rpc()
		else :
			push_error("Cannot end turn while not current turn")
	else :
		query_end_turn.rpc()

@rpc("authority", "call_local", "reliable")
func _apply_card_play(card_is_host : bool, card_index : int, target_is_host : bool, target_index : int) -> void :
	GameManager.get_player(card_is_host).play_card(card_index, GameManager.get_player(target_is_host).get_character(target_index))

@rpc("authority", "call_local", "reliable")
func _apply_end_turn() :
	_next_turn()

func _set_random_game_turn() -> void :
	_current_turn = Turn.CLIENT if NetworkManager.is_multiplayer and GameManager.rng.randi_range(0, 1) else Turn.HOST

func _next_turn() -> void :
	if _current_turn == Turn.NONE : 
		push_error("CANNOT DO TO NEXT TURN IF CURRENT TURN IS NONE")
		return
	elif _current_turn == Turn.HOST :
		_current_turn = Turn.CLIENT
		if !NetworkManager.is_multiplayer : 
			_next_turn()
	elif _current_turn == Turn.CLIENT : 
		_current_turn = Turn.HOST

func turn_is_none() -> bool :
	return _current_turn == Turn.NONE

func is_player_turn() -> bool :
	return !turn_is_none() and ((_current_turn == Turn.HOST) == GameManager.player.is_host)

func add_effect(effect : Effect, source : Character, target : Character) -> void :
	effect.source = source
	effect.target = target
	effect_stack.append(effect)
	if effect_stack.size() == 1 :
		_apply_effect()

func _apply_effect() -> void :
	effect_stack[0].apply()
	if ! effect_stack[0].is_done :
		await effect_stack[0].done
	effect_stack.remove_at(0)
	if effect_stack.size() > 0 :
		_apply_effect()
