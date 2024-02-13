extends Card

@export var energy_regen : int

func apply_effects(target : Character) -> void :
	_add_effect(DiscardCardEffect.new([false, false, true], character, character.player.get_opponent()))
	if position == Position.PREPARED_SLOT :
		_add_effect(RegenEnergyEffect.new(energy_regen, true, character, character.player))
