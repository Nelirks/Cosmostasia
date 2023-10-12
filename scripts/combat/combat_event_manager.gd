## Manages and redistributes events to Characters, ensuring the call order isn't random
extends Node
class_name CombatEventManager

func on_turn_start(is_host : bool) -> void :
	for i in range(3) :
		GameManager.combat.get_player_by_turn(true).get_character(i).on_turn_start(true)
	for i in range(3) :
		GameManager.combat.get_player_by_turn(false).get_character(i).on_turn_start(false)

func on_damage_dealt(source : Character, target : Character, amount : int) -> void :
	for i in range(3) :
		GameManager.combat.get_player_by_turn(true).get_character(i).on_damage_dealt(source, target, amount)
	for i in range(3) :
		GameManager.combat.get_player_by_turn(false).get_character(i).on_damage_dealt(source, target, amount)

func on_character_death(source : Character, target : Character) -> void :
	for i in range(3) :
		GameManager.combat.get_player_by_turn(true).get_character(i).on_character_death(source, target)
	for i in range(3) :
		GameManager.combat.get_player_by_turn(false).get_character(i).on_character_death(source, target)
