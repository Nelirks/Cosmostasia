extends Card

@export var base_armor : int
@export var bonus_armor : int

func apply_effects(target : Character) -> void :
	_add_effect(ApplyArmorEffect.new(base_armor + (bonus_armor if target.current_health * 2 < target.max_health else 0), character, target))
