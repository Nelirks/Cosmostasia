extends Node2D
class_name CardUI

var card: Card
var miracle_position: Vector2
var middle_position: Vector2
var prepared_position: Vector2

func on_position_set():
	match card.position:
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
