extends Control
class_name PlayableCard2D

var card: Card:
	set(value):
		card = value
		if card != null : 
			on_position_set()
			update_card_infos()
var miracle_position: Vector2
var middle_position: Vector2
var prepared_position: Vector2

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

func update_card_infos():
	(%Card_Title as Label).text = card.card_name
	(%Card_Cost as Label).text = str(card.cost)
	(%Card_Character as Label).text = str(card.character)
	(%CardDescription as RichTextLabel).text = card.description
	(%CardFlavorText as RichTextLabel).text = card.quote
