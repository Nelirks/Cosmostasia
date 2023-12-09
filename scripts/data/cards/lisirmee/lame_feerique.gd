extends Card

@export var miracle_cost : int
@export var base_cost : int
@export var prepared_cost : int
@export var miracle_damage : int
@export var base_damage : int
@export var prepared_damage : int

func apply_effects(target : Character) -> void :
	match position :
		Position.PREPARED_SLOT :
			_add_effect(DamageEffect.new(prepared_damage, character, target))
		Position.MIRACLE_SLOT :
			_add_effect(DamageEffect.new(miracle_damage, character, target))
		_ :
			_add_effect(DamageEffect.new(base_damage, character, target))

func _on_position_set() -> void :
	match position :
		Position.PREPARED_SLOT :
			cost = prepared_cost
		Position.MIRACLE_SLOT :
			cost = miracle_cost
		_ :
			cost = base_cost
