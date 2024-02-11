extends Card

@export var damage : int

func apply_effects(target : Character) -> void :
	for enemy in character.get_enemies() :
		_add_effect(DamageEffect.new(damage * character.player.last_turn_energy_regen, character, enemy))
	character.play_combat_vfx(preload("res://scenes/vfx_chloe/vfx slash.tscn"), null)
