extends Control
class_name PlayableCard2D

@export var borders : Array[Texture]

var card: Card:
	set(value):
		card = value
		if card != null : 
			update_card_infos()
			connect_signals()

func connect_signals() -> void :
	card.cost_updated.connect(update_cost)

func update_cost() -> void : 
	%CardCost.text = str(card.cost)

func update_name() -> void :
	%CardName.text = card.card_name

func update_borders() -> void :
	%CardBorders.texture = borders[card.cardType]

func update_flavor_text() -> void :
	%CardFlavorText.text = "[i]" + card.quote + "[/i]"

func update_description() -> void :
	%CardDescription.text = DescriptionHandler.develop_tags(card.description)

func update_texture() -> void :
	%CardSprite.texture = card.card_texture

func update_card_infos():
	update_cost()
	update_name()
	update_borders()
	update_flavor_text()
	update_description()
	update_texture()
