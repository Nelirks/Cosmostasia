extends Control

var selected_card : int

func _process(_delta: float) -> void:
	if GameManager.player == null : return
	($Console as RichTextLabel).text = "CURRENT TURN : " + ("PLAYER" if GameManager.combat.is_player_turn() else "OPPONENT") + "\n"
	($Console as RichTextLabel).text += "| "
	for i in range(3) :
		($Console as RichTextLabel).text += "%30s | " % GameManager.opponent.get_character(i).character_name
	($Console as RichTextLabel).text += "\n| "
	for i in range(3) :
		($Console as RichTextLabel).text += ("%18d" % GameManager.opponent.get_character(i).current_health) + ("(%d) /" %GameManager.opponent.get_character(i)._armor) + ("%10d" %GameManager.opponent.get_character(i).max_health) + " | "
	($Console as RichTextLabel).text += "\n\n| "
	for i in range(3) :
		($Console as RichTextLabel).text += "%30s | " % GameManager.player.get_character(i).character_name
	($Console as RichTextLabel).text += "\n| "
	for i in range(3) :
		($Console as RichTextLabel).text += ("%18d" % GameManager.player.get_character(i).current_health) + (" (%d) /" %GameManager.player.get_character(i)._armor)  + ("%10d" %GameManager.player.get_character(i).max_health) + " | "
	($Console as RichTextLabel).text += "\n\n| "
	for i in range(3) :
		($Console as RichTextLabel).text += "%30s | " % GameManager.player.get_card_in_hand(i).card_name
	($Console as RichTextLabel).text += str("\nEnergy : " + str(GameManager.player.current_energy) + " / " + str(GameManager.player.max_energy))
	($Console as RichTextLabel).text += "\n\n"

func _select_card(index : int) -> void :
	selected_card = index
	($Console as RichTextLabel).text += "Selected card " + GameManager.get_player(NetworkManager.is_host()).get_card_in_hand(selected_card).card_name + "\n"

func _target_character(is_ally : bool, index : int) -> void :
	if selected_card == -1 : 
		($Console as RichTextLabel).text += "No card selected" + "\n"
		return
	var target_is_host : bool = (is_ally and NetworkManager.is_host()) or (!is_ally and !NetworkManager.is_host())
	GameManager.combat.query_card_play(NetworkManager.is_host(), selected_card, target_is_host, index)
	selected_card = -1

func _input(event: InputEvent) -> void:
	if !GameManager.combat.is_player_turn() : return
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
			GameManager.combat.query_end_turn()
