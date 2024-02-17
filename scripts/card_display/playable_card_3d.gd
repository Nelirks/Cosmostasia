extends Card3D
class_name PlayableCard3D

@export var card_backs : Array[Texture]
@export var backside_dissolve_material : ShaderMaterial

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

var overlay : OverlayVFX :
	set(value) :
		_front_side.overlay = value

func use_text_color(use : bool) -> void :
	_front_side.use_text_color(use)

func dissolve(duration : float) -> void :
	if abs(rotation.y - PI) < 0.001 : 
		_front_side.visible = false
		_back_side.material = backside_dissolve_material
		var tween = create_tween()
		tween.tween_method(func(value) : backside_dissolve_material.set_shader_parameter("Progress", value), 0.0, 1.0, duration)
	else : 
		_back_side.visible = false
		_front_side.dissolve(duration)
