extends Effect
class_name RemoveStatusesEffect

var source : Character
var target : Character
var removes_positives : bool
var removes_negatives : bool
var removes_others : bool

func _init(removes_positives : bool, removes_negatives : bool, removes_others : bool, source : Character, target : Character) :
	self.removes_positives = removes_positives
	self.removes_negatives = removes_negatives
	self.removes_others = removes_others
	self.source = source
	self.target = target

func apply() -> void :
	for status in target._statuses : 
		if status.type == StatusEffect.StatusType.POSITIVE and removes_positives :
			target.remove_status(status)
		if status.type == StatusEffect.StatusType.NEGATIVE and removes_negatives :
			target.remove_status(status)
		if status.type == StatusEffect.StatusType.OTHER and removes_others :
			target.remove_status(status)
	is_done = true
