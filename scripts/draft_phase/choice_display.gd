extends Node
class_name ChoiceDisplay

signal selected()

var character : Character :
	set(value) :
		character = value
		if character != null :
			(%CharacterSprite as TextureRect).texture = character.character_texture
			(%CharacterName as Label).text = character.character_name

var is_selected : bool :
	set(value) : 
		if character == null : return
		is_selected = value
		if is_selected : selected.emit()
		print(character.character_name + " SELECTED")



func _on_gui_input(event):
	var mouse_click = event as InputEventMouseButton
	if mouse_click != null :
		if mouse_click.button_index == MOUSE_BUTTON_LEFT and mouse_click.pressed :
			is_selected = true
