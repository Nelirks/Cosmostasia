extends StackableStatusEffect

@export var damage : int

func on_effect_resolution(effect : Effect) -> void :
	if effect is StartTurnNotifierEffect and (effect as StartTurnNotifierEffect).player == owner.player :
		_add_effect(DamageEffect.new(damage, owner, owner, DamageEffect.DamageType.INDIRECT))
		stacks -= 1
