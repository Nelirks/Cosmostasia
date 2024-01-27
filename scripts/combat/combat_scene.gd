extends Node3D

@onready var player_hand : HandDisplay = %PlayerHand
@onready var opponent_hand : HandDisplay = %OpponentHand

func _on_character_clicked(is_host : bool, index : int) -> void :
	if player_hand.selected_card == null : return
	if player_hand.selected_card.card.targetting == Card.Targetting.NO_TARGET : return
	GameManager.combat.query_card_play(NetworkManager.is_host, player_hand.selected_card.card.position - 1, is_host, index)
	player_hand.deselect_card()

func _on_targetless_play_area_clicked() -> void :
	if player_hand.selected_card == null : return
	if player_hand.selected_card.card.targetting != Card.Targetting.NO_TARGET : return
	GameManager.combat.query_card_play(NetworkManager.is_host, player_hand.selected_card.card.position - 1, true, -1)

func _unhandled_input(event):
	var mouse_event = event as InputEventMouseButton
	if mouse_event == null or !mouse_event.pressed: return
	if  mouse_event.button_index == MOUSE_BUTTON_RIGHT :
		($PlayerHand as HandDisplay).deselect_card()

func _on_end_turn_button_pressed():
	GameManager.combat.query_end_turn()
