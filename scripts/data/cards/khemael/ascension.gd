extends Card

@export var damage : int
@export var heal : int
@export var stacks_threshold : int

func apply_effects(target : Character) -> void :
	character.get_status("khemael_passive").faveur_stacks = 0
	character.get_status("khemael_passive").prejudice_stacks = 0
	if target.player != character.player : 
		_add_effect(DamageEffect.new(damage, character, target))
	else : 
		_add_effect(HealEffect.new(heal, character, target))

func can_target(target : Character) -> bool :
	if character.has_status("khemael_passive") and character.get_status("khemael_passive").prejudice_stacks >= stacks_threshold :
		return character.player != target.player
	elif character.has_status("khemael_passive") and character.get_status("khemael_passive").faveur_stacks >= stacks_threshold :
		return character.player == target.player
	else : 
		return false
