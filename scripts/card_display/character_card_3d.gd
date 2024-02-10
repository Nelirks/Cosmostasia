extends Card3D
class_name CharacterCard3D

var card_2d_scene = preload("res://scenes/card_display/character_card_2d.tscn")

@export var is_combat_display : bool

var character : Character : 
	set(value) : 
		if _front_side == null : _front_side = card_2d_scene.instantiate()
		_front_side.character = value
		visible = character != null
	get :
		return _front_side.character if _front_side != null else null

var overlay : OverlayVFX :
	set(value) :
		_front_side.overlay = value

func _ready():
	visible = character != null
	_front_side.is_combat_display = is_combat_display
