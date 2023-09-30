extends Control

var selected_card : int

func _ready() -> void:
	GameManager.send_message.connect(_on_game_manager_send_message)
	if (NetworkManager.is_host()) :
		GameManager.query_action(InitCombatAction.new())

func _on_game_manager_send_message(message) -> void:
	($Console as RichTextLabel).text += message + "\n"

func _select_card(index : int) -> void :
	selected_card = index
	($Console as RichTextLabel).text += "Selected card " + GameManager.get_player(NetworkManager.is_host()).get_card_in_hand(selected_card).card_name + "\n"

func _target_character(is_ally : bool, index : int) -> void :
	if selected_card == -1 : 
		($Console as RichTextLabel).text += "No card selected" + "\n"
		return
	var card := CardSelector.new(NetworkManager.is_host(), selected_card)
	var target := CharacterSelector.new((is_ally and NetworkManager.is_host()) or (!is_ally and !NetworkManager.is_host()), index)
	GameManager.query_action(PlayCardAction.new(card, target))
	selected_card = -1

func _input(event: InputEvent) -> void:
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
