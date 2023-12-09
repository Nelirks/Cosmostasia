extends Card

var stunned_status : StatusEffect = preload("res://resources/game_data/status_effect_data/stunned_status.tres")

func apply_effects(target : Character) -> void :
	_add_effect(ApplyStatusEffect.new(stunned_status.duplicate(), character, character.get_status("lord_reece_passive").damage_source))

func can_target(target : Character) -> bool :
	if !character.has_status("lord_reece_passive") or character.get_status("lord_reece_passive").damage_source == null :
		return false
	return super.can_target(target)
