extends Effect
class_name RemoveStatusEffect

var source : Character
var target : Character
var status_id : String

func _init(status_id : String, source : Character, target : Character) :
	self.status_id = status_id
	self.source = source
	self.target = target

func apply() -> void :
	target.remove_status_by_id(status_id)
	is_done = true
