extends Card

var status_effect : StatusEffect = preload("res://resources/game_data/status_effect_data/preparation_status.tres")

@export var armor : int

func apply_effects(target : Character) -> void :
	_add_effect(ApplyStatusEffect.new(status_effect.duplicate(), character, character))
	_add_effect(ApplyArmorEffect.new(armor, character, character))
