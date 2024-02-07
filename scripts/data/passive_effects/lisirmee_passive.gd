extends StatusEffect

@export var damage : int

var cards_played : Array[bool]

func on_apply():
	cards_played = [false, false, false]

func on_effect_resolution(effect : Effect) -> void :
	if effect is CardPlayNotifierEffect and (effect as CardPlayNotifierEffect).card.character == owner : 
		cards_played[effect.card_position] = true
		if cards_played[0] and cards_played[1] and cards_played[2] :
			cards_played = [false, false, false]
			for target in owner.get_enemies() :
				_add_effect(DamageEffect.new(damage, owner, target))
