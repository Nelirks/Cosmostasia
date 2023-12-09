extends Resource
class_name Card

enum Type {ATTACK, DEFENSE, STRATEGY}

enum Targetting { ANY, ALLY, OPPONENT, NO_TARGET }

@export var card_name : String
@export var description : String
@export var quote : String
@export var cost : int
@export var targetting : Targetting
@export var cardType : Type

var character : Character

enum Position { DRAW_PILE, PREPARED_SLOT, MIDDLE_SLOT, MIRACLE_SLOT, DISCARD_PILE }
var position : Position :
	set(value) : 
		position = value
		_on_position_set()

func apply_effects(target : Character) -> void :
	pass

func can_target(target : Character) -> bool :
	if target == null : return targetting == Targetting.NO_TARGET
	if target.is_dead : return false
	
	if targetting == Targetting.ALLY : return character.player == target.player
	if targetting == Targetting.ANY and character.player == target.player : return true
	if (targetting == Targetting.ANY or targetting == Targetting.OPPONENT) and target.player != character.player :
		var aggro_level = int(target.has_status("provoke")) - int(target.has_status("stealth"))
		for potential_target in target.get_allies(false) :
			if aggro_level < (int(potential_target.has_status("provoke")) - int(potential_target.has_status("stealth"))) : return false
		return true
	return false

func _on_position_set() -> void :
	pass

func _add_effect(effect : Effect) -> void :
	GameManager.combat.add_effect(effect)
