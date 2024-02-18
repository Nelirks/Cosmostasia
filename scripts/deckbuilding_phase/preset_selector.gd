extends TextureButton
class_name PresetSelector

@export var selected_texture : Texture
@export var unselected_texture : Texture

var selected : bool :
	set(value) :
		selected = value
		texture_normal = selected_texture if selected else unselected_texture

func set_text(str : String) -> void :
	$Label.text = str
