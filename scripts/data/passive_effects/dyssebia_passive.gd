extends StatusEffect

@export var damage_received_multiplier : float

func on_effect_resolution(effect : Effect) -> void :
	if not effect is DamageEffect : return
	var damage_effect : DamageEffect = effect as DamageEffect
	var damage_source : Character = damage_effect.source
	if damage_effect.target.player != owner.player : return
	if damage_source.player == owner.player : return
	for enemy in damage_source.get_allies(false) :
		if enemy.current_health > damage_source.current_health : return
	damage_effect.add_damage_multiplier(damage_received_multiplier)
