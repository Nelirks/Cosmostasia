extends Card

@export var first_hit_damage : int
@export var feather_damage : int

func apply_effects(target : Character) -> void :
	_add_effect(DamageEffect.new(first_hit_damage, character, target))
	for enemy in character.get_enemies() :
		var damage = feather_damage * (enemy.get_status("feather").stacks if enemy.has_status("feather") else 0)
		if enemy == target : damage += feather_damage
		if damage > 0 :
			_add_effect(DamageEffect.new(damage, character, enemy))
	for enemy in character.get_enemies() :
		_add_effect(RemoveStatusEffect.new("feather", character, enemy))
