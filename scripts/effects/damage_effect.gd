extends Effect
class_name DamageEffect

var damage : int
var multiplier : float

enum damage_type { DIRECT, INDIRECT }

func apply() -> void :
	source.deal_damage(target, damage)
	is_done = true
