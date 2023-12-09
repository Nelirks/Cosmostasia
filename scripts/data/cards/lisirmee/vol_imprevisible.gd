extends Card

@export var stealth_stacks : int

var stealth_status : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/stealth_status_effect.tres")

func apply_effects(target : Character) -> void :
	_add_effect(ApplyStatusEffect.new(stealth_status.duplicate().set_stacks(stealth_stacks), character, character))
	var discard_pattern : Array[bool] = [position == Position.MIDDLE_SLOT, position == Position.PREPARED_SLOT or position == Position.MIRACLE_SLOT, position == Position.MIDDLE_SLOT]
	_add_effect(DiscardCardEffect.new(discard_pattern, character, character.player))
