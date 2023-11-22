extends Card

func apply_effects(target : Character) -> void :
	_add_effect(DiscardCardEffect.new([true, true, true], character, character.player))
	_add_effect(DiscardCardEffect.new([true, true, true], character, character.player.get_opponent()))
	for ally in character.get_allies() :
		_add_effect(RemoveStatusesEffect.new(true, true, false, character, ally))
		_add_effect(RemoveArmorEffect.new(character, ally))
	for enemy in character.get_enemies() :
		_add_effect(RemoveStatusesEffect.new(true, true, false, character, enemy))
		_add_effect(RemoveArmorEffect.new(character, enemy))
