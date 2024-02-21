extends Card

@export var damage : int
@export var damage_increase : int
@export var hp_threshold : int

func apply_effects(target : Character) -> void :
	_add_effect(DamageEffect.new(damage if character.current_health > hp_threshold else damage + damage_increase, character, target))
