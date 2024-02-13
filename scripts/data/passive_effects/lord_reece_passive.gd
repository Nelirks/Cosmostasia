extends StatusEffect

@export var heal_amount : int

var took_damage_last_turn : bool

func on_damage_taken(source : Character, amount : int) -> void :
	if source == null or source.player == owner.player : return
	took_damage_last_turn = true
	

func on_effect_resolution(effect : Effect) -> void :
	if effect is StartTurnNotifierEffect and effect.player == owner.player and !took_damage_last_turn :
		_add_effect(HealEffect.new(heal_amount, owner, owner))

func end_turn() -> void :
	took_damage_last_turn = false
