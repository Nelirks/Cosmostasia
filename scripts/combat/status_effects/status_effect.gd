extends Resource
class_name StatusEffect

enum StatusType { POSITIVE, NEGATIVE, SPECIAL }

@export var id : String
@export var type : StatusType
@export var description : String
var owner : Character
	
func start_turn() -> void :
	pass

func end_turn() -> void :
	pass

func apply(target : Character) -> void :
	target.add_status(self)

func on_damage_taken(source : Character, amout : int) -> void :
	pass

func on_apply() -> void :
	pass

func on_remove() -> void :
	pass

func on_effect_resolution(effect : Effect) -> void :
	pass

func _add_effect(effect : Effect) -> void :
	GameManager.combat.add_effect(effect)
