extends RefCounted
class_name StatusEffect

var id : String
var owner : Character

func _init() -> void :
	id = "default_status"
	
func decay() -> void :
	pass

func apply(target : Character) -> void :
	target.add_status(self)

func on_apply() -> void :
	print(id + " applied to " + owner.char_name)

func on_remove() -> void :
	print(id + " removed from " + owner.char_name)

func on_effect_resolution(effect : Effect) -> void :
	pass
