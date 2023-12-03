extends Card

@export var armor : int
@export var energy_regen : int

func apply_effects(target : Character) -> void :
	_add_effect(ApplyArmorEffect.new(armor, character, character))
	_add_effect(RegenEnergyEffect.new(energy_regen, false, character, character.player))
