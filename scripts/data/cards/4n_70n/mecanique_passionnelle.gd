extends Card

@export var damage : int
@export var energy_gain : int
@export var armor : int

func apply_effects(target : Character) -> void :
	var emotion : int = character.get_status("4n_70n_passive").emotion if character.has_status("4n_70n_passive") else -1
	match emotion :
		0 : 
			for enemy in character.get_enemies() :
				_add_effect(DamageEffect.new(damage, character, enemy, DamageEffect.DamageType.DIRECT, false))
			character.play_combat_vfx(preload("res://scenes/vfx_chloe/vfx slash.tscn"), null)
		1 : 
			_add_effect(RegenEnergyEffect.new(energy_gain, true, character, character.player))
		2 :
			_add_effect(ApplyArmorEffect.new(armor, character, character))
