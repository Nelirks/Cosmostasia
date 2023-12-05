extends Card

@export var damage : int

func apply_effects(target : Character) -> void :
	_add_effect(RemoveStatusesEffect.new(false, true, character, target))
	_add_effect(DamageEffect.new(damage, character, target))
