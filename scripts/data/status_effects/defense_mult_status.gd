extends StackableStatusEffect

@export var damage_received_multiplier : float

func on_effect_resolution(effect : Effect) -> void :
	var damage_effect = (effect as DamageEffect)
	if damage_effect != null and damage_effect.target == owner :
		damage_effect.add_damage_multiplier(damage_received_multiplier)

func start_turn() -> void :
	stacks -= 1
