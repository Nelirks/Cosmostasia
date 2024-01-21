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
	
	match card.cardType:
		card.Type.ATTACK:
			%Attack_Border.visible = true
			%Defense_Border.visible = false
			%Strategy_Border.visible = false
		card.Type.DEFENSE:
			%Attack_Border.visible = false
			%Defense_Border.visible = true
			%Strategy_Border.visible = false
		card.Type.STRATEGY:
			%Attack_Border.visible = false
			%Defense_Border.visible = false
			%Strategy_Border.visible = true
