extends Card3D
class_name PlayableCard3D

var card_2d_scene = preload("res://scenes/card_display/playable_card_2d.tscn")

@export var card_backs : Array[Texture]

var card : 
	set(value) : 
		if _front_side == null : _front_side = card_2d_scene.instantiate()
		_front_side.card = value
		_front_side.scale = Vector2(2.5, 2.5)
		_back_side = TextureRect.new()
		_back_side.texture = card_backs[card.cardType]
		_back_side.scale = Vector2(0.5, 0.5)
	get :
		return _front_side.card if _front_side != null else null

var miracle_position: Vector3
var middle_position: Vector3
var prepared_position: Vector3

func on_position_set():
	match card.Position:
		Card.Position.DRAW_PILE: 
			visible = false
		Card.Position.PREPARED_SLOT:
			position = prepared_position
		Card.Position.MIDDLE_SLOT:
			position = middle_position
		Card.Position.MIRACLE_SLOT:
			position = miracle_position
		Card.Position.DISCARD_PILE:
			visible = false
