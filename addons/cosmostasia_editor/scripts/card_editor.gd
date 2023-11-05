@tool
extends Control
class_name CardEditor

@onready var _card_selector : CardSelector = %CardSelector
@onready var _card_fields : DataFieldContainer = %CardFields

var character : CharacterInfo :
	set(value) :
		character = value
		_card_selector.character = character

var card : CardInfo :
	set(value) :
		card = value
		if _card_fields != null :
			_card_fields.resource = card

func _ready() -> void:
	character = null
	card = null

func _on_card_selected(card : CardInfo) -> void:
	self.card = card
