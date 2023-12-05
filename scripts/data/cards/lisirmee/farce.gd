extends Card

@export var energy_regen : int

func apply_effects(target : Character) -> void :
	_add_effect(DiscardCardEffect.new([true, true, true], character, character.player))
	_add_effect(RegenEnergyEffect.new(energy_regen, true, character, character.player))