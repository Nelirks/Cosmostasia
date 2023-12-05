extends Card

@export var armor : int

func apply_effects(target : Character) -> void :
	_add_effect(RemoveStatusesEffect.new(false, true, character, target))
	_add_effect(ApplyArmorEffect.new(armor, character, target))
