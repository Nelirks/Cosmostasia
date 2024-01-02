extends Node
class_name PickDisplay

var character : Character :
	set(value) : 
		character = value
		if character != null :
			(%CharacterSprite as TextureRect).texture = character.character_texture
			(%CharacterName as Label).text = character.character_name

