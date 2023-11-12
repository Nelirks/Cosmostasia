extends Effect
class_name DamageEffect

var damage : int
var source : Character
var target : Character

func _init(damage : int, source : Character, target : Character) :
	self.damage = damage
	self.source = source
	self.target = target

func apply() -> void :
	source.deal_damage(target, damage)
	is_done = true
