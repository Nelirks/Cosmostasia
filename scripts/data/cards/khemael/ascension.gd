extends Card

@export var damage_per_stack : int
@export var heal_per_stack : int

func apply_effects(target : Character) -> void :
	if target.player != character.player : 
		_add_effect(DamageEffect.new(damage_per_stack * character.get_status("khemael_passive").prejudice_stacks, character, target))
	else : 
		_add_effect(HealEffect.new(heal_per_stack * character.get_status("khemael_passive").faveur_stacks, character, target))
	character.get_status("khemael_passive").faveur_stacks = 0
	character.get_status("khemael_passive").prejudice_stacks = 0

func can_target(target : Character) -> bool :
	if character.has_status("khemael_passive") and character.get_status("khemael_passive").prejudice_stacks > 0 :
		return character.player != target.player
	elif character.has_status("khemael_passive") and character.get_status("khemael_passive").faveur_stacks > 0 :
		return character.player == target.player
	else : 
		return true
