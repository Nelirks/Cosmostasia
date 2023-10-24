extends CombatEvent
class_name DamageDealtEvent

var source : Character
var target : Character
var amount : int

func _init(source : Character, target : Character, amount : int) :
	self.source = source
	self.target = target
	self.amount = amount
