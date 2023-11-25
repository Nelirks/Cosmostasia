extends Resource
class_name Card

enum Type {ATTACK, DEFENSE, STRATEGY}

enum Targetting { ANY, SELF, ALLY, OPPONENT }

@export var card_name : String
@export var description : String
@export var quote : String
@export var cost : int
@export var targetting : Targetting
@export var cardType : Type

var character : Character

func apply_effects(target : Character) -> void :
	pass

func can_target(target : Character) -> bool :
	match targetting :
		Targetting.ANY :
			return true
		Targetting.SELF :
			return character == target
		Targetting.ALLY :
			return character.player == target.player
		Targetting.OPPONENT :
			if character.player == target.player : return false
			var aggro_level = int(target.has_status("provoke")) - int(target.has_status("stealth"))
			for potential_target in target.get_allies(false) :
				if aggro_level < (int(potential_target.has_status("provoke")) - int(potential_target.has_status("stealth"))) : return false
			return true
	return false

func _add_effect(effect : Effect) -> void :
	GameManager.combat.add_effect(effect)
