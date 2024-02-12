extends Card

@export var armor : int
@export var provoke_stacks : int
var provoke_status : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/provoke_status_effect.tres")

func apply_effects(target : Character) -> void :
	_add_effect(ApplyArmorEffect.new(armor, character, character))
	_add_effect(ApplyStatusEffect.new(provoke_status.duplicate().set_stacks(provoke_stacks), character, character))
