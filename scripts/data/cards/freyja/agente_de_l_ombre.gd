extends Card

var stealth_effect : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/stealth_status_effect.tres")
@export var stealth_duration : int
@export var heal_amount : int

func apply_effects(target : Character) -> void :
	_add_effect(ApplyStatusEffect.new(stealth_effect.duplicate().set_stacks(stealth_duration), character, character))
	_add_effect(HealEffect.new(heal_amount, character, character))
