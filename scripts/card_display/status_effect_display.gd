extends Node
class_name StatusEffectDisplay

func update_texture(texture : Texture2D) -> void :
	%TextureRect.texture = texture

func update_amount(amount : int) -> void :
	%Label.text = str(amount)
