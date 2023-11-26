extends StatusEffect
class_name StackableStatusEffect

var stacks : int :
	set(value) :
		stacks = value
		_on_stacks_changed()

func set_stacks(stacks : int) -> StackableStatusEffect :
	self.stacks = stacks
	return self

func apply(target : Character) -> void :
	if !target.has_status(id) : super.apply(target)
	else :
		(target.get_status(id) as StackableStatusEffect).stacks += stacks

func _on_stacks_changed() -> void : 
	pass
