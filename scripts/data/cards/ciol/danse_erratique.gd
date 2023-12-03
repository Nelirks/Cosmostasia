extends Card

@export var damage : int

func apply_effects(target : Character) -> void :
	_add_effect(DanseErratiqueEffect.new(damage, character, target))
