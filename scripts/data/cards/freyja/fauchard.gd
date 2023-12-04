extends Card

@export var damage : int

func apply_effects(target : Character) -> void :
	for enemy in character.get_enemies() :
		_add_effect(DamageEffect.new(damage, character, enemy))
