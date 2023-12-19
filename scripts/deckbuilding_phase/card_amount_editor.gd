extends Node
class_name CardAmountEditor

var card : Card : 
	set(value) : 
		card = value
		(%CardName as Label).text = card.card_name

var amount : int :
	set(value) :
		amount = value
		(%CardAmount as Label).text = str(amount)
