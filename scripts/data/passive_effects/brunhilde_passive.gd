extends StatusEffect

var active : bool
@export var hp_threshold : int
@export var damage_dealt_multiplier : float
@export var damage_received_multiplier : float

func on_apply() -> void :
	active = false
	super.on_apply()

func on_effect_resolution(effect : Effect) -> void :
	if effect is CardPlayNotifierEffect :
		active = owner.current_health <= hp_threshold
	if not active : return
	var damage_effect : DamageEffect = effect as DamageEffect
	if damage_effect != null :
		if damage_effect.target == owner :
			damage_effect.add_damage_multiplier(damage_received_multiplier)
		if damage_effect.source == owner : 
			damage_effect.add_damage_multiplier(damage_dealt_multiplier)
