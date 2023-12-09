extends ExclusiveStatusEffect

func end_turn() -> void :
	owner.remove_status(self)
