extends RefCounted
class_name StatusEffect

var id : String
var owner : Character

func _init(id : String) -> void :
	self.id = id
	
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
