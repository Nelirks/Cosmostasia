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
			return character.player != target.player
	return false

func _add_effect(effect : Effect) -> void :
	GameManager.combat.add_effect(effect)
