extends Card

@export var energy_regen : int

func apply_effects(target : Character) -> void :
	_add_effect(RevealCardEffect.new(GameManager.rng.randi_range(0, 2), character, character.player.get_opponent()))
	_add_effect(RegenEnergyEffect.new(energy_regen, false, character, character.player))
