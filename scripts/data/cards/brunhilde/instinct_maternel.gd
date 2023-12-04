extends Card

@export var provoke_stacks : int
@export var defense_up_duration : int

var provoke_status : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/provoke_status_effect.tres")
var defense_up_status : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/defense_up_status.tres")

func apply_effects(target : Character) -> void :
	_add_effect(ApplyStatusEffect.new(provoke_status.duplicate().set_stacks(provoke_stacks), character, character))
	_add_effect(ApplyStatusEffect.new(defense_up_status.duplicate().set_stacks(defense_up_duration), character, character))
