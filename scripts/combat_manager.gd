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
var action_queue : Array[Action]

signal effect_stack_emptied()
signal action_queue_emptied()

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
	_add_action(PlayCardAction.new(card_is_host, card_index, target_is_host, target_index))

@rpc("authority", "call_local", "reliable")
func _apply_end_turn() :
	_add_action(EndTurnAction.new())

func _set_random_game_turn() -> void :
	_current_turn = Turn.CLIENT if NetworkManager.is_multiplayer and GameManager.rng.randi_range(0, 1) else Turn.HOST

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
	else :
		effect_stack_emptied.emit()

func _add_action(action : Action) :
	action_queue.append(action)
	if action_queue.size() == 1 :
		_apply_action()

func _apply_action() :
	action_queue[0].apply()
	if !effect_stack.size() == 0 :
		await effect_stack_emptied
	action_queue.remove_at(0)
	if action_queue.size() > 0:
		_apply_action()
	else :
		action_queue_emptied.emit()
