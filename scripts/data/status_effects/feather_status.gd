extends StackableStatusEffect

func apply(target : Character) -> void :
	if target.has_status(id) :
		var max_feathers = 0
		for enemy in target.get_enemies() :
			if enemy.has_status("ciol_passive") :
				max_feathers += enemy.get_status("ciol_passive").stacks
		stacks = clamp(stacks, 0, max_feathers - target.get_status("feather").stacks)
	if stacks > 0 :
		super.apply(target)
