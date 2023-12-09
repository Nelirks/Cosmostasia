extends Card

@export var regen_reduction : int
@export var armor : int

func apply_effects(target : Character) -> void :
	_add_effect(ApplyArmorEffect.new(armor, character, target))
	_add_effect(RegenEnergyEffect.new(-regen_reduction, false, character, character.player.get_opponent()))
