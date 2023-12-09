extends Card

@export var stacks : int

var damage_up : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/permanent_damage_up_status.tres")

func apply_effects(target : Character) -> void :
	_add_effect(ApplyStatusEffect.new(damage_up.duplicate().set_stacks(stacks), character, character))
