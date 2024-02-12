extends Card

@export var damage : int

func apply_effects(target : Character) -> void :
	_add_effect(RemoveStatusesEffect.new(true, false, character, target))
	_add_effect(DamageEffect.new(damage, character, target))
