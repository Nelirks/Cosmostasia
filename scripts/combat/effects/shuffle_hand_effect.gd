extends Effect
class_name ShuffleHandEffect

var source : Character
var target : Player

func _init(source : Character, target : Player) :
	self.source = source
	self.target = target

func apply() -> void :
	for cur_index in range(target._hand.size()) :
		var swap_index : int = GameManager.rng.randi_range(0, target._hand.size() - 1)
		var tmp : Card = target._hand[cur_index]
		target._hand[cur_index] = target._hand[swap_index]
		target._hand[swap_index] = tmp
	is_done = true
