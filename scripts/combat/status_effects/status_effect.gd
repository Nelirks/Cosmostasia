extends Resource
class_name StatusEffect

enum StatusType { POSITIVE, NEGATIVE, SPECIAL }

@export var id : String
@export var type : StatusType
var owner : Character
	
func start_turn() -> void :
	pass

func end_turn() -> void :
	pass

func apply(target : Character) -> void :
	target.add_status(self)

func on_apply() -> void :
	print(id + " applied to " + owner.character_name)

func on_remove() -> void :
	print(id + " removed from " + owner.character_name)

func on_effect_resolution(effect : Effect) -> void :
	pass

func _add_effect(effect : Effect) -> void :
	GameManager.combat.add_effect(effect)
