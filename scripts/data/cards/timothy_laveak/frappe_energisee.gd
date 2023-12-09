extends Card

@export var damage : int
@export var armor : int

func apply_effects(target : Character) -> void :
	_add_effect(DamageEffect.new(damage, character, target))
	if character.player.current_energy > 0 :
		_add_effect(ApplyArmorEffect.new(armor, character, character))
