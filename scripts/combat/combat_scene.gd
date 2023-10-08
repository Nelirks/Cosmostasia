extends Control

var selected_card : int

func _ready() -> void:
	GameManager.synced_state.connect(_on_state_synced)
	GameManager.set_game_state(GameManager.GameState.COMBAT)

func _on_state_synced(state) -> void :
	if state != GameManager.GameState.COMBAT : 
		push_error("STATE IS SUPPOSED TO BE COMBAT")
		return
	if NetworkManager.is_host() :
		start_game.rpc()

func _process(_delta: float) -> void:
	if GameManager.player == null : return
	($Console as RichTextLabel).text = "CURRENT TURN : " + ("PLAYER" if GameManager.is_player_turn() else "OPPONENT") + "\n"
	($Console as RichTextLabel).text += "| "
	for i in range(3) :
		($Console as RichTextLabel).text += "%30s | " % GameManager.opponent.get_character(i).char_name
	($Console as RichTextLabel).text += "\n| "
	for i in range(3) :
		($Console as RichTextLabel).text += ("%18d / " % GameManager.opponent.get_character(i).current_health) + ("%10d | " %GameManager.get_player(false).get_character(i).max_health)
	($Console as RichTextLabel).text += "\n\n| "
	for i in range(3) :
		($Console as RichTextLabel).text += "%30s | " % GameManager.player.get_character(i).char_name
	($Console as RichTextLabel).text += "\n| "
	for i in range(3) :
		($Console as RichTextLabel).text += ("%18d / " % GameManager.player.get_character(i).current_health) + ("%10d | " %GameManager.get_player(false).get_character(i).max_health)
	($Console as RichTextLabel).text += "\n\n| "
	for i in range(3) :
		($Console as RichTextLabel).text += "%30s | " % GameManager.player.get_card_in_hand(i).card_name
	($Console as RichTextLabel).text += str("\nEnergy : " + str(GameManager.player.current_energy) + " / " + str(GameManager.player.max_energy))
	($Console as RichTextLabel).text += "\n\n"

@rpc("authority", "call_local", "reliable")
func start_game() :
	GameManager.player = Player.new(NetworkManager.is_host())
	GameManager.opponent = Player.new(!NetworkManager.is_host())
	GameManager.get_player(true).shuffle_draw_pile()
	GameManager.get_player(true).refill_hand()
	GameManager.get_player(false).shuffle_draw_pile()
	GameManager.get_player(false).refill_hand()
	GameManager.set_random_game_turn()

@rpc("any_peer", "call_remote", "reliable")
func query_card_play(card_is_host : bool, card_index : int, target_is_host : bool, target_index : int) -> void :
	#Apply checks
	if NetworkManager.is_host() :
		_apply_card_play.rpc(card_is_host, card_index, target_is_host, target_index)
	else :
		query_card_play.rpc(card_is_host, card_index, target_is_host, target_index)

@rpc("authority", "call_local", "reliable")
func _apply_card_play(card_is_host : bool, card_index : int, target_is_host : bool, target_index : int) -> void :
	GameManager.get_player(card_is_host).play_card(card_index, GameManager.get_player(target_is_host).get_character(target_index))

@rpc("any_peer", "call_remote", "reliable")
func query_end_turn() -> void :
	if NetworkManager.is_host() :
		if !GameManager.turn_is_none() and ((multiplayer.get_remote_sender_id() == 0) == GameManager.is_player_turn()) :
			_apply_end_turn.rpc()
		else :
			push_error("Cannot end turn while not current turn")
	else :
		query_end_turn.rpc()

@rpc("authority", "call_local", "reliable")
func _apply_end_turn() :
	GameManager.next_turn()

func _select_card(index : int) -> void :
	selected_card = index
	($Console as RichTextLabel).text += "Selected card " + GameManager.get_player(NetworkManager.is_host()).get_card_in_hand(selected_card).card_name + "\n"

func _target_character(is_ally : bool, index : int) -> void :
	if selected_card == -1 : 
		($Console as RichTextLabel).text += "No card selected" + "\n"
		return
	var target_is_host : bool = (is_ally and NetworkManager.is_host()) or (!is_ally and !NetworkManager.is_host())
	query_card_play(NetworkManager.is_host(), selected_card, target_is_host, index)
	selected_card = -1

func _input(event: InputEvent) -> void:
	if !GameManager.is_player_turn() : return
	if !(event is InputEventKey and event.is_pressed()) : return
	var key = (event as InputEventKey).keycode
	match key :
		KEY_KP_1 :
			_select_card(0)
		KEY_KP_2 : 
			_select_card(1)
		KEY_KP_3 : 
			_select_card(2)
		KEY_KP_4 :
			_target_character(true, 0)
		KEY_KP_5 :
			_target_character(true, 1)
		KEY_KP_6 :
			_target_character(true, 2)
		KEY_KP_7 :
			_target_character(false, 0)
		KEY_KP_8 :
			_target_character(false, 1)
		KEY_KP_9 :
			_target_character(false, 2)
		KEY_SPACE :
			query_end_turn()
