extends StackableStatusEffect

@export var damage_multiplier : float

func on_effect_resolution(effect : Effect) -> void :
	var damage_effect = (effect as DamageEffect)
	if damage_effect != null and damage_effect.source == owner :
		print("REDUCTION APPLIED")
		damage_effect.add_damage_multiplier(damage_multiplier)

func end_turn() -> void :
	stacks -= 1
