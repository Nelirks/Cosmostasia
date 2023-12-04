extends StatusEffect

@export var damage_multiplier : float
@export var self_damage : int

var active : bool
var damage_dealt : bool

func on_effect_resolution(effect : Effect) -> void :
	if effect is CardPlayNotifierEffect :
		active = false
		return
	if not active : return
	
	var damage_effect : DamageEffect = effect as DamageEffect
	if damage_effect != null and damage_effect.source == owner and damage_effect.target.player != owner.player :
		damage_effect.add_damage_multiplier(damage_multiplier)
		if not damage_dealt :
			_add_effect(DamageEffect.new(self_damage, owner, owner))
			damage_dealt = true

func start_turn() -> void :
	active = true
	damage_dealt = false
