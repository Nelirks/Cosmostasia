extends StatusEffect

@export var heal_amount : int

var damage_taken : int
var damage_source : Character

func on_damage_taken(source : Character, amount : int) -> void :
	if source == null or source.player == owner.player : return
	damage_source = source
	damage_taken = amount
	

func on_effect_resolution(effect : Effect) -> void :
	if effect is StartTurnNotifierEffect and effect.player == owner.player :
		_add_effect(HealEffect.new(heal_amount, owner, owner))
	if effect is StartTurnNotifierEffect and effect.player != owner.player : 
		damage_taken = 0
		damage_source = null
