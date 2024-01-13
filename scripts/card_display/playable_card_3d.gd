extends Card3D
class_name PlayableCard3D

var card_2d_scene = preload("res://scenes/card_display/playable_card_2d.tscn")

var card : 
	set(value) : 
		if _front_side == null : _front_side = card_2d_scene.instantiate()
		_front_side.card = value
	get :
		return _front_side.character if _front_side != null else null

func _ready():
	card = preload("res://resources/game_data/card_data/4N-70N/saute_d_humeur.tres")
