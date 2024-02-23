extends Card

func apply_effects(target : Character) -> void :
	_add_effect(DiscardCardEffect.new([false, false, true], character, character.player.get_opponent()))
	if position == Position.PREPARED_SLOT :
		_add_effect(ApplyStatusEffect.new(preload("res://resources/game_data/status_effect_data/provoke_status_effect.tres").duplicate().set_stacks(1), character, character))
