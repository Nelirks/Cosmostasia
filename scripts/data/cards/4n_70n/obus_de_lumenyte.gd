extends Card

@export var damage : int
@export var hit_count : int

func apply_effects(target : Character) -> void :
	for hit in range(hit_count) : 
		_add_effect(DamageEffect.new(damage, character, target))
