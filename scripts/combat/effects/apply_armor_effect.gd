extends Effect
class_name ApplyArmorEffect

var amount : int
var source : Character
var target : Character

func _init(amount : int, source : Character, target : Character) :
	self.amount  = amount
	self.source = source
	self.target = target

func apply() -> void :
	target.apply_armor(amount)
	is_done = true
