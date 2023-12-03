extends StackableStatusEffect

func decay() -> void :
	owner.remove_status(self)
