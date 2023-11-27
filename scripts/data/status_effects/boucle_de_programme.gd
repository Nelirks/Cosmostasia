extends StackableStatusEffect

@export var armor : int

func on_effect_resolution(effect : Effect) -> void :
	if effect is CardPlayNotifierEffect and (effect as CardPlayNotifierEffect).card.character == owner :
		_add_effect(ApplyArmorEffect.new(armor, owner, owner))
		stacks -= 1
