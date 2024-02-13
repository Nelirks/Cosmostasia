extends StatusEffect

@export var anger_damage_mult : float
@export var joy_energy_regen : int
@export var sadness_damage_mult : float

@export var anger_icon : Texture
@export var joy_icon : Texture
@export var sadness_icon : Texture

enum Emotion { ANGER, JOY, SADNESS, NONE }
var emotion : Emotion

func on_apply():
	emotion = Emotion.NONE

func on_effect_resolution(effect : Effect) -> void :
	match emotion :
		Emotion.ANGER :
			if effect is DamageEffect and (effect.source == owner or effect.target == owner) :
				(effect as DamageEffect).add_damage_multiplier(anger_damage_mult)
		Emotion.SADNESS :
			if effect is DamageEffect and (effect.source == owner or effect.target == owner) :
				(effect as DamageEffect).add_damage_multiplier(sadness_damage_mult)
		Emotion.JOY :
			if effect is StartTurnNotifierEffect and (effect as StartTurnNotifierEffect).player == owner.player :
				_add_effect(RegenEnergyEffect.new(joy_energy_regen, false, owner, owner.player))
	if effect is CardPlayNotifierEffect and (effect as CardPlayNotifierEffect).card.character == owner : 
		set_emotion((effect as CardPlayNotifierEffect).card_position)

func set_emotion(card_position : int) :
	var energy_regen_modification = 0
	if owner.has_status("boucle_de_programme") and owner.get_status("boucle_de_programme").active : return
	if emotion == Emotion.JOY : 
		energy_regen_modification -= joy_energy_regen
	emotion = card_position
	if emotion == Emotion.JOY :
		energy_regen_modification += joy_energy_regen
	if energy_regen_modification != 0 :
		_add_effect(RegenEnergyEffect.new(energy_regen_modification, false, owner, owner.player))
	status_updated.emit()

func get_texture() -> Texture :
	match emotion :
		Emotion.ANGER :
			return anger_icon
		Emotion.JOY :
			return joy_icon
		Emotion.SADNESS :
			return sadness_icon
	return null
