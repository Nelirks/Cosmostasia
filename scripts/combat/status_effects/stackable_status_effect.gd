extends StatusEffect
class_name StackableStatusEffect

var stacks : int :
	set(value) :
		stacks = value
		_on_stacks_changed()
		print("Set " + id + " stacks to " + str(stacks))

func set_stacks(stacks : int) -> StackableStatusEffect :
	self.stacks = stacks
	return self

func apply(target : Character) -> void :
	if !target.has_status(id) : super.apply(target)
	else :
		(target.get_status(id) as StackableStatusEffect).stacks += stacks

func _on_stacks_changed() -> void : 
	if stacks <= 0 : 
		if owner != null : owner.remove_status(self)
