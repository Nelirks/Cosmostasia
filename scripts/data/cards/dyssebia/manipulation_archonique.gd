extends Card

@export var base_damage : int
@export var bonus_damage : int

func apply_effects(target : Character) -> void :
	var final_damage = base_damage + (bonus_damage if character._armor > 0 else 0)
	_add_effect(DamageEffect.new(final_damage, character, target))
