extends Card

@export var damage : int
@export var armor : int

func apply_effects(target : Character) -> void :
	_add_effect(DamageEffect.new(damage, character, target))
	_add_effect(ConditionalEffect.new(EnergyRemainingCondition.new(character.player, 1), [], [ApplyArmorEffect.new(armor, character, character)]))
