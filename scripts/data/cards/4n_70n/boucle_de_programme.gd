extends Card

var status_effect : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/boucle_de_programme.tres")
@export var armor : int
@export var stacks : int

func apply_effects(target : Character) -> void :
	_add_effect(ApplyArmorEffect.new(armor, character, character))
	_add_effect(ApplyStatusEffect.new(status_effect.duplicate().set_stacks(stacks), character, character))
