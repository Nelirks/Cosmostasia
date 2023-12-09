extends Effect
class_name CardPlayNotifierEffect

var card : Card
var card_position : int
var target : Character

func _init(card : Card, card_position : int, target : Character) :
	self.card = card
	self.card_position = card_position
	self.target = target
