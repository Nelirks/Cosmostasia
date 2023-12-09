extends Card

func apply_effects(target : Character) -> void :
	_add_effect(DiscardCardEffect.new([false, false, true], character, character.player.get_opponent()))
