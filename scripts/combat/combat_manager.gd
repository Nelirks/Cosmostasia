extends Node
class_name CombatManager

signal turn_set()
signal combat_end()

enum Turn { HOST, CLIENT }
var _current_turn : Turn :
	set (value) :
		get_player_by_turn(true).end_turn()
		_current_turn = value
		turn_set.emit()
		get_player_by_turn(true).start_turn()

## Stores pending effects, in queue order. Effects will resolve as soon as the previous one is done resolving.
var effect_queue : Array[Effect]
var current_effect : Effect
## Stores pending actions, in queue order. Actions when resolve as soon as no more effects are pending.
## This prevents actions from causing desync when called while an other action resolves.
var action_queue : Array[Action]

signal effect_queue_emptied()
signal action_queue_emptied()

## Initializes all combat relevant data.
@rpc("authority", "call_local", "reliable")
func start_game() :
	_add_action(StartGameAction.new())

## Try to play a card. If network is used, the client sends this request to the host.
@rpc("any_peer", "call_remote", "reliable")
func query_card_play(card_is_host : bool, card_index : int, target_is_host : bool, target_index : int) -> void :
	var card : Card = GameManager.get_player(card_is_host).get_card_in_hand(card_index)
	var target : Character = GameManager.get_player(target_is_host).get_character(target_index)
	if !card.character.player.can_play_card(card, target) : return
	
	if NetworkManager.is_host :
		_apply_card_play.rpc(card_is_host, card_index, target_is_host, target_index)
	else :
		query_card_play.rpc(card_is_host, card_index, target_is_host, target_index)

## Try to end the turn. If network is used, the client sends this request to the host.
@rpc("any_peer", "call_remote", "reliable")
func query_end_turn() -> void :
	if NetworkManager.is_host :
		if ((multiplayer.get_remote_sender_id() == 0) == is_player_turn()) :
			_apply_end_turn.rpc()
		else :
			printerr("Cannot end turn while not current turn")
	else :
		query_end_turn.rpc()

## Plays a card. This function should ony be called by the host, who sends it to the client.
@rpc("authority", "call_local", "reliable")
func _apply_card_play(card_is_host : bool, card_index : int, target_is_host : bool, target_index : int) -> void :
	var card : Card = GameManager.get_player(card_is_host).get_card_in_hand(card_index)
	var target : Character = GameManager.get_player(target_is_host).get_character(target_index)
	_add_action(PlayCardAction.new(card, target))

## Ends the trun. This function should only be called by the host, who sends it to the client.
@rpc("authority", "call_local", "reliable")
func _apply_end_turn() -> void :
	_add_action(EndTurnAction.new())

func _set_random_game_turn() -> void :
	_current_turn = Turn.CLIENT if NetworkManager.is_multiplayer and GameManager.rng.randi_range(0, 1) else Turn.HOST

## Goes to next turn.
## In single player mode, automatically skip the opponent's turn.
func next_turn() -> void :
	if _current_turn == Turn.HOST :
		_current_turn = Turn.CLIENT
		if !NetworkManager.is_multiplayer : 
			next_turn()
	else :
		_current_turn = Turn.HOST

func is_player_turn() -> bool :
	return ((_current_turn == Turn.HOST) == GameManager.player.is_host)

func get_player_by_turn(active_player : bool) -> Player :
	if active_player == is_player_turn() :
		return GameManager.player
	else :
		return GameManager.opponent

## Adds an effect to the queue, to be resolved after all previous effects did so.
## If no effect is currently resolving, starts resolving effects in queue order.
func add_effect(effect : Effect) -> void :
	if action_queue.size() == 0 : printerr("Effect added while action queue is empty")
	effect_queue.push_back(effect)
	pass

## Adds multiple effects to the queue, to be resolved after all previous effects did so.
## If no effect is currently resolving, starts resolving effects in queue order.
func add_effects(effects : Array[Effect]) -> void :
	for index in range(0, effects.size()) :
		add_effect(effects[index])

## Adds an effect in front of the queue, to be resolved before other effects.
## Should only be called by "wrapper" effects, and will lock the game if used while no effect is active.
## To call this multiple times, use add_effects_immediate or add the effects in reverse execution order.
func add_effect_immediate(effect : Effect) -> void :
	effect_queue.push_front(effect)

## Adds multiple effects in front of the queue, to be resolved before other effects.
## Should only be called by "wrapper" effects, and will lock the game if used while no effect is active.
func add_effects_immediate(effects : Array[Effect]) -> void :
	for index in range(effects.size()-1, -1, -1) :
		add_effect_immediate(effects[index])

## Applies the first pending effect, and the following ones if any.
## Emits effect_queue_emptied when no more effects are pending.
func _apply_effect() -> void :
	while effect_queue.size() > 0 :
		current_effect = effect_queue.pop_front()
		emit_effect_resolution(current_effect)
		current_effect.apply()
		if ! current_effect.is_done :
			await current_effect.done
	current_effect = null
	effect_queue_emptied.emit()

## Adds an action to the queue, and applies it if action is currently active.
func _add_action(action : Action) -> void :
	action_queue.append(action)
	if action_queue.size() == 1 :
		_apply_action()

## Applies the first pending action, and the following ones if any.
## Checks game state after each action, and emits action_queue_emptied when no more actions are pending.
func _apply_action() -> void :
	while action_queue.size() > 0 :
		action_queue[0].apply()
		_apply_effect()
		if current_effect != null or effect_queue.size() != 0 :
			await effect_queue_emptied
		_check_game_state()
		if action_queue.size() > 0 : action_queue.remove_at(0)
	action_queue_emptied.emit()

## Updates characters is_dead value, then checks if a player wins the game.
func _check_game_state() -> void :
	var previous_min_team_size : int = mini(get_player_by_turn(true).get_characters().size(), get_player_by_turn(false).get_characters().size())
	for char in get_player_by_turn(true).get_characters() :
		char.check_game_state()
	for char in get_player_by_turn(false).get_characters() :
		char.check_game_state()
	var min_team_size : int = mini(get_player_by_turn(true).get_characters().size(), get_player_by_turn(false).get_characters().size())
	if min_team_size < previous_min_team_size :
		AudioManager.post_event([AK.EVENTS.END_COMBATMUSIC, AK.EVENTS.SWITCH_PHASE03, AK.EVENTS.SWITCH_PHASE02][min_team_size])
	get_player_by_turn(true).refill_hand()
	get_player_by_turn(false).refill_hand()
	_check_victory()

func _check_victory() -> void :
	if get_player_by_turn(true).get_characters().size() == 0 or get_player_by_turn(false).get_characters().size() == 0 :
		action_queue = []
		combat_end.emit()

func emit_effect_resolution(effect : Effect) -> void :
	for char in get_player_by_turn(true).get_characters() :
		char.on_effect_resolution(effect)
	for char in get_player_by_turn(false).get_characters() :
		char.on_effect_resolution(effect)
