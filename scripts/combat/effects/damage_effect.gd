extends Effect
class_name DamageEffect

var damage : int
var multiplier : float

var source : Character
var target : Character

enum DamageType { DIRECT, INDIRECT }
var damage_type : DamageType

func _init(damage : int, source : Character, target : Character, damage_type : DamageType = DamageType.DIRECT) :
	self.damage = damage
	multiplier = 1
	self.source = source
	self.target = target
	self.damage_type = damage_type

func apply() -> void :
	source.deal_damage(target, damage)
	is_done = true
