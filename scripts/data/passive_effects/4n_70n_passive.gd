extends StatusEffect

enum Emotion { ANGER, JOY, SADNESS, NONE }
var emotion : Emotion

func on_apply():
	emotion = Emotion.NONE

func on_effect_resolution(effect : Effect) -> void :
	match emotion :
		Emotion.ANGER :
			if effect is DamageEffect and (effect.source == owner or effect.target == owner) :
				(effect as DamageEffect).add_damage_multiplier(0.2)
		Emotion.SADNESS :
			if effect is DamageEffect and (effect.source == owner or effect.target == owner) :
				(effect as DamageEffect).add_damage_multiplier(-0.2)
		Emotion.JOY :
			if effect is StartTurnNotifierEffect and (effect as StartTurnNotifierEffect).player == owner.player :
				owner.player.energy_regen += 1
	if effect is CardPlayNotifierEffect and (effect as CardPlayNotifierEffect).card.character == owner : 
		set_emotion((effect as CardPlayNotifierEffect).card_position)

func set_emotion(card_position : int) :
	if emotion == Emotion.JOY : 
		owner.player.energy_regen -= 1
	emotion = card_position
	if emotion == Emotion.JOY :
		owner.player.energy_regen += 1
