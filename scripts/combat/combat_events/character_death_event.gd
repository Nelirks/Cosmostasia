extends CombatEvent
class_name CharacterDeathEvent

var character : Character

func _init(character : Character) -> void :
	self.character = character
