extends Resource
class_name CharacterInfo

@export_group("Character Data")
@export var character_name : String
@export var character_quote : String
@export var character_texture : Texture2D

@export_group("Gameplay Data")
@export var max_health : int
@export var character_cards : Array[CardInfo]
