extends Effect
class_name CardPlayNotifierEffect

var card : Card
var card_position : int

func _init(card : Card, card_position : int) :
	self.card = card
	self.card_position = card_position
