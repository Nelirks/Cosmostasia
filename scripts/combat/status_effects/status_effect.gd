extends Resource
class_name StatusEffect

enum StatusType { POSITIVE, NEGATIVE, SPECIAL }

@export var id : String
@export var type : StatusType
var owner : Character
	
func decay() -> void :
	pass

func apply(target : Character) -> void :
	target.add_status(self)

func on_apply() -> void :
	print(id + " applied to " + owner.character_name)

func on_remove() -> void :
	print(id + " removed from " + owner.character_name)

func on_effect_resolution(effect : Effect) -> void :
	pass
