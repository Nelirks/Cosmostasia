extends Card

@export var damage : int
@export var heal : int

func apply_effects(target : Character) -> void :
	var target_ally : Character
	for ally in character.get_allies() :
		if target_ally == null or target_ally.current_health > ally.current_health :
			target_ally = ally
	
	_add_effect(DamageEffect.new(damage, character, target))
	_add_effect(HealEffect.new(heal, character, target_ally))
