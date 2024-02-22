extends Card

@export var damage_per_stack : int
@export var armor_per_stack : int

func apply_effects(target : Character) -> void :
	if target.player != character.player : 
		_add_effect(DamageEffect.new(damage_per_stack * character.get_status("khemael_passive").stacks, character, target))
	else : 
		_add_effect(ApplyArmorEffect.new(armor_per_stack * character.get_status("khemael_passive").stacks, character, target))
	character.get_status("khemael_passive").stacks = 0

func can_target(target : Character) -> bool :
	if target == null or target.is_dead : return false
	if !character.has_status("khemael_passive") or character.get_status("khemael_passive").stacks == 0 : return true
	if character.get_status("khemael_passive").state == 0 :
		targetting = Targetting.ALLY
		return super.can_target(target)
	elif character.get_status("khemael_passive").state == 1 :
		targetting = Targetting.OPPONENT
		return super.can_target(target)
	else : 
		return true
