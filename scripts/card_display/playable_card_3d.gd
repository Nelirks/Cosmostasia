extends Card3D
class_name PlayableCard3D

@export var card_backs : Array[Texture]

var card : Card :  
	set(value) : 
		if _front_side.card != null and _front_side.card.revealed_applied.is_connected(flip) :
			_front_side.card.revealed_applied.disconnect(flip)
		_front_side.card = value
		_back_side.texture = card_backs[card.cardType]
		_back_side.scale = Vector2(0.5, 0.5)
		card.revealed_applied.connect(flip.bind(false, 0.5))
	get :
		return _front_side.card if _front_side != null else null

func set_overlay(overlay_material : Material) -> void :
	_front_side.set_overlay(overlay_material)

func use_text_color(use : bool) -> void :
	_front_side.use_text_color(use)
