extends Node
class_name Card

var template : CardInfo
var card_name : String
var cost : int
var description : String
var quote : String
var effects

var character : Character

func _init(template : CardInfo, character : Character) :
	self.template = template
	card_name = template.card_name
	cost = template.card_cost
	description = template.card_description
	quote = template.card_quote
	effects = template.card_effect.duplicate(true)
	self.character = character

func play(target : Character) :
	for effect in effects :
		effect.apply(character, target)
