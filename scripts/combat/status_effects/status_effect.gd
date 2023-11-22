extends RefCounted
class_name StatusEffect

enum StatusType { POSITIVE, NEGATIVE, OTHER }

var id : String
var type : StatusType
var owner : Character

func _init(id : String, type : StatusType) -> void :
	self.id = id
	self.type = type
	
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
