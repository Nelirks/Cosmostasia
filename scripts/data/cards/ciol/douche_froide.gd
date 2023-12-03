extends Card

@export var damage : int

var attack_down_status : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/attack_down_status.tres")

func apply_effects(target : Character) -> void :
	_add_effect(DamageEffect.new(damage, target, character))
	var status_stacks = (target.get_status("feather").stacks + 1) if target.has_status("feather") else 1
	_add_effect(ApplyStatusEffect.new(attack_down_status.duplicate().set_stacks(status_stacks), character, target))
