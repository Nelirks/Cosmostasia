extends Card

@export var base_damage : int
@export var feather_damage : int

func apply_effects(target : Character) -> void :
	_add_effect(DamageEffect.new(base_damage + (feather_damage if target.has_status("feather") else 0), character, target))
