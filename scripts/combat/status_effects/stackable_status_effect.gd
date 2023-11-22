extends StatusEffect
class_name StackableStatusEffect

var stacks : int :
	set(value) :
		stacks = value
		_on_stacks_changed()

func _init(id : String, type : StatusType, stacks : int) :
	self.id = id
	self.type = type
	self.stacks = stacks

func apply(target : Character) -> void :
	if !target.has_status(id) : super.apply(target)
	else :
		(target.get_status(id) as StackableStatusEffect).stacks += stacks

func _on_stacks_changed() -> void : 
	pass
