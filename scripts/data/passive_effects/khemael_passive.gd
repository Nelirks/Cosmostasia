extends StackableStatusEffect

enum State { FAVEUR, PREJUDICE }

var state : State = State.FAVEUR

@export var prejudice_multiplier : float
@export var faveur_multiplier : float

@export var faveur_icon : Texture
@export var prejudice_icon : Texture

func on_effect_resolution(effect : Effect) -> void :
	if effect is CardPlayNotifierEffect and effect.card.character == owner :
		if effect.target != null and effect.target.player == owner.player :
			if state == State.PREJUDICE and stacks > 0 :
				stacks -= 1
			else : 
				state = State.FAVEUR
				stacks += 1
		else :
			if state == State.FAVEUR and stacks > 0 :
				stacks -= 1
			else :
				state = State.PREJUDICE
				stacks += 1
		return
	var damage_effect : DamageEffect = effect as DamageEffect
	if damage_effect != null :
		if damage_effect.source == owner and state == State.PREJUDICE and stacks > 0 :
			damage_effect.add_damage_multiplier(prejudice_multiplier)
		elif damage_effect.target != owner and damage_effect.target.player == owner.player and state == State.FAVEUR and stacks > 0 :
			damage_effect.add_damage_multiplier(faveur_multiplier)

func _on_stacks_changed() -> void : 
	status_updated.emit()

func get_texture() -> Texture :
	if stacks == 0 : return null
	if state == State.FAVEUR :
		return faveur_icon
	else :
		return prejudice_icon
