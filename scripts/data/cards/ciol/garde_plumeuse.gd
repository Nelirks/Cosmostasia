extends Card

@export var armor_per_feather : int

func apply_effects(target : Character) -> void :
	var armor_gain : int = 0
	for enemy in character.get_enemies() :
		if enemy.has_status("feather") :
			armor_gain += armor_per_feather * enemy.get_status("feather").stacks
			_add_effect(RemoveStatusEffect.new("feather", character, enemy))
	_add_effect(ApplyArmorEffect.new(armor_gain, character, character))
