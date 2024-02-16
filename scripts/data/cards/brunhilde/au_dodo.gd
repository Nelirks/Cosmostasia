extends Card

@export var damage : int
var stunned_status = preload("res://resources/game_data/status_effect_data/stunned_status.tres")

func apply_effects(target : Character) -> void :
	_add_effect(DamageEffect.new(damage, character, target))
	_add_effect(ApplyStatusEffect.new(stunned_status.duplicate(), character, target))

func can_target(target : Character) -> bool :
	if target == null : return false
	if target.player == character.player : return false
	for enemy in target.get_allies(false, false) :
		if enemy.current_health < target.current_health : return false
		if enemy.current_health == target.current_health :
			if enemy.has_status("provoke") and !target.has_status("provoke") : return false
			if !enemy.has_status("stealth") and target.has_status("stealth") : return false
	return true
