extends Resource
class_name Cards

enum type {SingleTarget, AOE}

@export var cardName : String
@export var cardDescription : String
@export var cardQuote : String
@export var cardCost : int
@export var cardType : type
@export var cardEffect : Array[Effect]
