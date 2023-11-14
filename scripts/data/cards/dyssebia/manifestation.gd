extends Card

@export var armor : int
@export var provoke_stacks : int

func apply_effects(target : Character) -> void :
	_add_effect(ApplyArmorEffect.new(armor, character, target))
	_add_effect(ApplyStatusEffect.new(ProvokeStatusEffect.new(provoke_stacks), character, target))
