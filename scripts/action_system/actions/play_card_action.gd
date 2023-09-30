extends Action
class_name PlayCardAction

var card_selector : CardSelector
var char_selector : CharacterSelector

func _init(card_selector : CardSelector = null, char_selector : CharacterSelector = null) :
	self.card_selector = card_selector
	self.char_selector = char_selector
	
func apply() -> void :
	GameManager.get_player(card_selector.player_is_host).play_card(card_selector.index, GameManager.get_character(char_selector))
