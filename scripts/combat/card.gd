extends Node
class_name Card

var card_name : String
var cost : int
var character : Character

func _init(card_name : String, cost : int, character : Character) :
	self.card_name = card_name
	self.cost = cost
	self.character = character

func play(target : Character) :
	DebugEffect.new(card_name + " PLAYED FROM " + character.char_name + " TARGETTING " + target.char_name).apply()
