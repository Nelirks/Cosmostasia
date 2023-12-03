extends Card

@export var energy_regen_reduction : int

func apply_effects(target : Character) -> void :
	_add_effect(ShuffleHandEffect.new(character, character.player.get_opponent()))
	_add_effect(RegenEnergyEffect.new(-energy_regen_reduction, false, character, character.player.get_opponent()))
