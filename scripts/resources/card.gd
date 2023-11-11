extends Resource
class_name Card

#enum type {SingleTarget, AOE}

@export var card_name : String
@export var description : String
@export var quote : String
@export var cost : int
#@export var cardType : type

var character : Character

func apply_effects(target : Character) :
	pass

func _add_effect(effect : Effect) -> void :
	GameManager.combat.add_effect(effect)
