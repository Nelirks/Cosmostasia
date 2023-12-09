extends Node2D

var character: Character

func update_health():
	(%Life_Background as ColorRect).set_size(Vector2(character.current_health / character.max_health * 150, 16))

func update_sprite():
	(%Character_Sprite as TextureRect).texture = character.sprite
