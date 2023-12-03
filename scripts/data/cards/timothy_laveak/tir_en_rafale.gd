extends Card

@export var damage : int
@export var damage_increase : int
var rafale_status : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/rafale_effect.tres")

func apply_effects(target : Character) -> void :
	_add_effect(DamageEffect.new(damage + (character.get_status(rafale_status.id).stacks if character.has_status(rafale_status.id) else 0), character, target))
	_add_effect(ApplyStatusEffect.new(rafale_status.duplicate().set_stacks(5), character, character))
