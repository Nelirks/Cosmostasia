extends Card3D
class_name CharacterCard3D

var card_2d_scene = preload("res://scenes/card_display/character_card_2d.tscn")

var character : 
	set(value) : 
		if _front_side == null : _front_side = card_2d_scene.instantiate()
		_front_side.character = value
		visible = character != null
	get :
		return _front_side.character if _front_side != null else null

func set_overlay(material : Material) :
	if _front_side == null : return
	_front_side.set_overlay(material)

func _ready():
	visible = character != null
