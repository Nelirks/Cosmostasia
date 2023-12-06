extends Card

func apply_effects(target : Character) -> void :
	_add_effect(DamageEffect.new(character.get_status("lord_reece_passive").damage_taken, character, target))

func can_target(target : Character) -> bool :
	if !character.has_status("lord_reece_passive") or character.get_status("lord_reece_passive").damage_taken == 0 :
		return false
	return super.can_target(target)
