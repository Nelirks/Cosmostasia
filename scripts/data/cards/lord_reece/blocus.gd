extends Card

var attack_down_status : StatusEffect = preload("res://resources/game_data/status_effect_data/attack_down_status.tres")
var stunned_status : StatusEffect = preload("res://resources/game_data/status_effect_data/stunned_status.tres")

@export var attack_down_duration : int

func apply_effects(target : Character) -> void :
	_add_effect(ApplyStatusEffect.new(attack_down_status.duplicate().set_stacks(attack_down_duration), character, target))
	if character.get_status("lord_reece_passive").took_damage_last_turn :
		_add_effect(ApplyStatusEffect.new(stunned_status.duplicate(), character, target))
