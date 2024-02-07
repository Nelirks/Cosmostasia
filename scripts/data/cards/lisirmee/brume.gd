extends Card

@export var poison_duration : int
@export var attack_down_duration : int

var poison_status : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/poison_status.tres")
var attack_down_status : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/attack_down_status.tres")

func apply_effects(target : Character) -> void :
	if position == Position.PREPARED_SLOT :
		for enemy in target.get_allies() :
			_add_effect(ApplyStatusEffect.new(attack_down_status.duplicate().set_stacks(attack_down_duration), character, enemy))
	else :
		_add_effect(ApplyStatusEffect.new(attack_down_status.duplicate().set_stacks(attack_down_duration), character, target))
	if position == Position.MIRACLE_SLOT :
		_add_effect(ApplyStatusEffect.new(poison_status.duplicate().set_stacks(poison_duration), character, target))
