extends Card

@export var damage : int
var stunned_status = preload("res://resources/game_data/status_effect_data/stunned_status.tres")

func apply_effects(target : Character) -> void :
	var lowest_health_enemy : Character = character.get_enemies()[0]
	for enemy in character.get_enemies() :
		if lowest_health_enemy.current_health > enemy.current_health :
			lowest_health_enemy = enemy
	
	_add_effect(DamageEffect.new(damage, character, lowest_health_enemy))
	_add_effect(ApplyStatusEffect.new(stunned_status.duplicate(), character, lowest_health_enemy))
