extends Resource
class_name Card

enum Type {ATTACK, DEFENSE, STRATEGY}

enum Targetting { ANY, ALLY, OPPONENT, NO_TARGET }

signal position_changed()
signal cost_updated()
signal revealed_applied()

@export var card_name : String
@export_multiline var description : String
@export_multiline var quote : String
@export var cost : int :
	set(value) : 
		cost = value
		cost_updated.emit()
@export var targetting : Targetting
@export var cardType : Type
@export var card_texture : Texture

var character : Character

enum Position { DRAW_PILE, PREPARED_SLOT, MIDDLE_SLOT, MIRACLE_SLOT, DISCARD_PILE }
var position : Position :
	set(value) : 
		position = value
		position_changed.emit()
		_on_position_set()

var revealed : bool = false :
	set(value) :
		revealed = value
		if revealed :
			print("CARD REVEALED")
			revealed_applied.emit()
			if !position_changed.is_connected(_reset_reveal) :
				position_changed.connect(_reset_reveal)

var is_in_hand : bool :
	get :
		return position == Position.PREPARED_SLOT or position == Position.MIDDLE_SLOT or position == Position.MIRACLE_SLOT


func apply_effects(target : Character) -> void :
	pass

func can_target(target : Character) -> bool :
	if target == null : return targetting == Targetting.NO_TARGET
	if target.is_dead : return false
	
	if targetting == Targetting.ALLY : return character.player == target.player
	if targetting == Targetting.ANY and character.player == target.player : return true
	if (targetting == Targetting.ANY or targetting == Targetting.OPPONENT) and target.player != character.player :
		var aggro_level = int(target.has_status("provoke")) - int(target.has_status("stealth"))
		for potential_target in target.get_allies(false) :
			if aggro_level < (int(potential_target.has_status("provoke")) - int(potential_target.has_status("stealth"))) : return false
		return true
	return false

func _on_position_set() -> void :
	pass

func _add_effect(effect : Effect) -> void :
	GameManager.combat.add_effect(effect)

func _reset_reveal() :
	if position == Position.DISCARD_PILE or position == Position.DRAW_PILE :
		revealed = false
		revealed_applied.disconnect(_reset_reveal)
