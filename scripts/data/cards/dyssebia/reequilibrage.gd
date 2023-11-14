extends Card

@export var damage : int
@export var heal : int

func apply_effects(target : Character) -> void :
	var target_ally : Character
	for ally in character.get_allies() :
		if target_ally == null or target_ally.current_health > ally.current_health :
			target_ally = ally
	var target_enemy : Character
	for enemy in character.get_enemies() :
		if target_enemy == null or target_enemy.current_health < enemy.current_health :
			target_enemy = enemy
	
	_add_effect(DamageEffect.new(damage, character, target_enemy))
	_add_effect(HealEffect.new(heal, character, target_ally))
