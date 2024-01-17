extends Control
class_name PlayableCard2D

var card: Card:
	set(value):
		card = value
		if card != null : 
			update_card_infos()

func update_card_infos():
	(%Card_Title as Label).text = card.card_name
	(%Card_Cost as Label).text = str(card.cost)
	(%Card_Character as Label).text = card.character.character_name
	(%CardDescription as RichTextLabel).text = card.description
	(%CardFlavorText as RichTextLabel).text = card.quote
