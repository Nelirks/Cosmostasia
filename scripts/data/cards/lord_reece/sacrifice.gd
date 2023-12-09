extends Card

@export var damage : int
@export var attack_down_duration : int

var attack_down_status : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/attack_down_status.tres")

func apply_effects(target : Character) -> void :
	_add_effect(ApplyStatusEffect.new(attack_down_status.duplicate().set_stacks(attack_down_duration), character, target))
	var negative_effect_amount = 1
	for status in target._statuses :
		if status.type == StatusEffect.StatusType.NEGATIVE and status.id != attack_down_status.id :
			negative_effect_amount += 1
	_add_effect(DamageEffect.new(negative_effect_amount * damage, character, target))
