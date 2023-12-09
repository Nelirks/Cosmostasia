extends Effect
class_name RemoveArmorEffect

var source : Character
var target : Character

func _init(source : Character, target : Character) :
	self.source = source
	self.target = target

func apply() -> void :
	target.remove_armor()
	is_done = true
