extends StatusEffect

var faveur_stacks : int
var prejudice_stacks : int

@export var prejudice_multiplier : float
@export var faveur_multiplier : float

func on_effect_resolution(effect : Effect) -> void :
	if effect is CardPlayNotifierEffect and effect.card.character == owner :
		if effect.target != null and effect.target.player == owner.player :
			if prejudice_stacks > 0 : prejudice_stacks -= 1
			else : faveur_stacks += 1
		else :
			if faveur_stacks > 0 : faveur_stacks -= 1
			else : prejudice_stacks += 1
		return
	var damage_effect : DamageEffect = effect as DamageEffect
	if damage_effect != null :
		if damage_effect.source == owner and prejudice_stacks > 0 :
			damage_effect.add_damage_multiplier(prejudice_multiplier)
		elif damage_effect.target != owner and damage_effect.target.player == owner.player and faveur_stacks > 0 :
			damage_effect.add_damage_multiplier(faveur_stacks)
