extends Node3D

func _on_character_clicked(is_host : bool, index : int) -> void :
	var selected_card : int = ($PlayerHand as HandDisplay).get_selected_card_index()
	if selected_card != -1 :
		GameManager.combat.query_card_play(NetworkManager.is_host, selected_card, is_host, index)
		($PlayerHand as HandDisplay).deselect_card()

func _on_targetless_play_area_clicked() -> void :
	var selected_card : int = ($PlayerHand as HandDisplay).get_selected_card_index()
	if selected_card != -1 :
		GameManager.combat.query_card_play(NetworkManager.is_host, selected_card, true, -1)

func _unhandled_input(event):
	var mouse_event = event as InputEventMouseButton
	if mouse_event == null or !mouse_event.pressed: return
	if  mouse_event.button_index == MOUSE_BUTTON_RIGHT :
		($PlayerHand as HandDisplay).deselect_card()


func _on_end_turn_button_pressed():
	GameManager.combat.query_end_turn()
