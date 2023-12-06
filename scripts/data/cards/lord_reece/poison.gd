extends Card

@export var poison_duration : int

var poison_status : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/poison_status.tres")

func apply_effects(target : Character) -> void :
	_add_effect(ApplyStatusEffect.new(poison_status.duplicate().set_stacks(poison_duration), character, target))
