extends Effect
class_name ShuffleDrawPileEffect

var target_is_host : bool

func _init(target_is_host : bool) :
	self.target_is_host = target_is_host

func apply(source : Character, target : Character) -> void :
	GameManager.get_player(target_is_host).shuffle_draw_pile()
