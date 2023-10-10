extends Effect
class_name DamageEffect

@export var damage : int

func apply() -> void :
	source.deal_damage(target, damage)
	is_done = true
