extends Card

@export var base_damage : int
@export var bonus_damage : int

func apply_effects(target : Character) -> void :
	_add_effect(DamageEffect.new(base_damage + (bonus_damage if target.current_health * 2 < target.max_health else 0), character, target))
