extends Control

var selected_card : int = -1

func _process(_delta: float) -> void:
	if GameManager.player == null : return
	var display : String = ""
	display += "CURRENT TURN : " + ("PLAYER" if GameManager.combat.is_player_turn() else "OPPONENT") + "\n\n"
	
	display += "OPPONENT CHARACTERS : \n"
	for enemy in GameManager.opponent._characters : 
		display += enemy.character_name + " -- " + str(enemy.current_health) + " (" + str(enemy._armor) + ") / " + str(enemy.max_health) + "\n"
		for status in enemy._statuses :
			display += "   " + status.id + "\n"
	
	display += "ALLY CHARACTERS : \n"
	for ally in GameManager.player._characters : 
		display += ally.character_name + " -- " + str(ally.current_health) + " (" + str(ally._armor) + ") / " + str(ally.max_health) + "\n"
		for status in ally._statuses :
			display += "   " + status.id + "\n"
	
	display += "HAND : \n"
	for i in range(3) :
		var is_selected : bool = i == selected_card
		if is_selected : display += "[b]"
		display += "%30s | " % GameManager.player.get_card_in_hand(i).card_name if GameManager.player.get_card_in_hand(i) != null else "EMPTY"
		if is_selected : display += "[/b]"
	display += str("\nEnergy : " + str(GameManager.player.current_energy) + " / " + str(GameManager.player.max_energy))
	($Console as RichTextLabel).text = display

func _select_card(index : int) -> void :
	selected_card = index

func _target_character(is_ally : bool, index : int) -> void :
	if selected_card == -1 : return
	var target_is_host : bool = (is_ally and NetworkManager.is_host) or (!is_ally and !NetworkManager.is_host)
	GameManager.combat.query_card_play(NetworkManager.is_host, selected_card, target_is_host, index)
	selected_card = -1

func _input(event: InputEvent) -> void:
	if !GameManager.combat.is_player_turn() : return
	if !(event is InputEventKey and event.is_pressed()) : return
	var key = (event as InputEventKey).keycode
	match key :
		KEY_KP_0 :
			_target_character(true, -1)
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
			GameManager.combat.query_end_turn()
