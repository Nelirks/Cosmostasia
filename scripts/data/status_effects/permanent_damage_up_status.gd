extends StackableStatusEffect

func on_effect_resolution(effect : Effect) -> void :
	var damage_effect : DamageEffect = (effect as DamageEffect)
	if damage_effect != null and damage_effect.source == owner :
		(effect as DamageEffect).add_fixed_damage(stacks) 
