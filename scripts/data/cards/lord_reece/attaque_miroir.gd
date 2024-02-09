extends Card

@export var base_damage : int
@export var damage_increase : int

func apply_effects(target : Character) -> void :
	var damage_increased : bool = character.get_status("lord_reece_passive").took_damage_last_turn
	print(damage_increased)
	_add_effect(DamageEffect.new(base_damage + (damage_increase if damage_increased else 0), character, target))
