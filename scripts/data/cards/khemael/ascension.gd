extends Card

@export var damage_per_stack : int
@export var heal_per_stack : int

func apply_effects(target : Character) -> void :
	if target.player != character.player : 
		_add_effect(DamageEffect.new(damage_per_stack * character.get_status("khemael_passive").stacks, character, target))
	else : 
		_add_effect(HealEffect.new(heal_per_stack * character.get_status("khemael_passive").stacks, character, target))
	character.get_status("khemael_passive").stacks = 0

func can_target(target : Character) -> bool :
	if target == null or target.is_dead : return false
	if !character.has_status("khemael_passive") or character.get_status("khemael_passive").stacks == 0 : return true
	if character.get_status("khemael_passive").state == 0 :
		return character.player == target.player
	elif character.get_status("khemael_passive").state == 1 :
		return character.player != target.player
	else : 
		return true
