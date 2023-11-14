extends Card

@export var base_armor : int
@export var bonus_armor : int

func apply_effects(target : Character) -> void :
	var bonus_multiplier : int = 3 - character.get_allies().size()
	for ally in target.get_allies() :
		_add_effect(ApplyArmorEffect.new(base_armor + bonus_multiplier * bonus_armor, character, ally))
