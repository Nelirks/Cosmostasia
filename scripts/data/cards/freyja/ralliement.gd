extends Card

var status_effect : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/attack_up_status.tres")

@export var attack_buff_duration : int

func apply_effects(target : Character) -> void :
	for ally in character.get_allies() :
		_add_effect(ApplyStatusEffect.new(status_effect.duplicate().set_stacks(attack_buff_duration), character, ally))
