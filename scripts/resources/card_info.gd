extends Resource
class_name CardInfo

#enum type {SingleTarget, AOE}

@export var card_name : String
@export var card_description : String
@export var card_quote : String
@export var card_cost : int
#@export var cardType : type
@export var card_effect : Array[Effect]
