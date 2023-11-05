@tool
extends Control
class_name CardEditor

@onready var _card_selector : OptionButton = %CardSelector

var character : CharacterInfo :
	set(value) :
		character = value
		_card_selector.clear()
		if character != null :
			for card in character.character_cards :
				_card_selector.add_item(card.card_name)

func _on_create_card_button_pressed() -> void:
	character.character_cards.append(CardInfo.new())
