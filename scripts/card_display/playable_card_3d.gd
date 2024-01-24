extends Card3D
class_name PlayableCard3D

@export var card_backs : Array[Texture]

func _ready():
	print("TEST")

var card : Card :  
	set(value) : 
		print(_front_side)
		_front_side.card = value
		_back_side.texture = card_backs[card.cardType]
		_back_side.scale = Vector2(0.5, 0.5)
	
	get :
		return _front_side.card if _front_side != null else null
