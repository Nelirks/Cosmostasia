@tool
extends Control
class_name CharacterSelector

signal hover_entered()
signal hover_exited()
signal clicked()

@export var flipped : bool :  
	set(value) : 
		flipped = value
		set_flip(flipped)

func set_text(text : String) -> void :
	%CharacterName.text = text

func set_flip(flip : bool) -> void :
	(%Background as TextureRect).flip_h = flip
	(%CharacterName as Label).horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT if flip else HORIZONTAL_ALIGNMENT_RIGHT


func _on_gui_input(event):
	var mouse_event = event as InputEventMouseButton
	if mouse_event and mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT :
		clicked.emit()



func _on_mouse_entered():
	hover_entered.emit()


func _on_mouse_exited():
	hover_exited.emit()
