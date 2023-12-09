extends Card

@export var defense_up_duration : int
var defense_up_status = preload("res://resources/game_data/status_effect_data/defense_up_status.tres")

func apply_effects(target : Character) -> void :
	for ally in character.get_allies() :
		_add_effect(ApplyStatusEffect.new(defense_up_status.duplicate().set_stacks(defense_up_duration), character, ally))
