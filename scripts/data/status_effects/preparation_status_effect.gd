extends StatusEffect

@export var damage_multiplier : float

var active : bool

func on_apply() -> void :
	active = false
	super.on_apply()

func on_effect_resolution(effect : Effect) -> void :
	if !active : return
	var damage_effect : DamageEffect = effect as DamageEffect
	if damage_effect != null and damage_effect and damage_effect.source == owner and damage_effect.target.player != owner.player :
		damage_effect.add_damage_multiplier(damage_multiplier)

func start_turn() -> void :
	if active : 
		owner.remove_status(self)
	else :
		active = true
