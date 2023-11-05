@tool
extends Control
class_name CardSelector

signal card_selected(card : CardInfo)
@onready var _card_picker : OptionButton = %CardPicker

var character : CharacterInfo :
	set(value) :
		character = value
		visible = character != null
		_update_card_picker()

var card : CardInfo :
	set(value) :
		card = value
		card_selected.emit(card)

func _on_create_card_button_pressed() -> void:
	if character != null :
		character.character_cards.append(CardInfo.new())
		_update_card_picker(character.character_cards.size() - 1)

func _on_delete_card_button_pressed() -> void:
	if character != null and _card_picker.selected != -1 :
		character.character_cards.remove_at(_card_picker.selected)
	_update_card_picker()

func _on_reload_selector_button_pressed() -> void:
	_update_card_picker()

func _update_card_picker(select_index : int = -1) -> void :
	_card_picker.clear()
	if character != null :
		for card in character.character_cards :
			_card_picker.add_item(card.card_name)
	_card_picker.select(select_index)
	if character == null or select_index < 0 : card = null
	else : card = character.character_cards[_card_picker.selected]

func _on_card_picked(index: int) -> void:
	card = character.character_cards[index]
