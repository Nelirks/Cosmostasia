extends StackableStatusEffect

func on_effect_resolution(effect : Effect) -> void :
	if effect is CardPlayNotifierEffect :
		if effect.card.character.player != owner.player and effect.card.targetting == Card.Targetting.OPPONENT :
			stacks -= 1
