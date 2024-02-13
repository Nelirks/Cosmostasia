extends Effect
class_name RevealCardEffect

var source : Character
var target : Player
var card_index : int

func _init(card_index : int, source : Character, target : Player) :
	self.card_index = card_index
	self.source = source
	self.target = target

func apply() -> void :
	target.get_card_in_hand(card_index).revealed = true
	is_done = true
