@tool
extends Control
class_name CharacterFields

@onready var _field_container : Control = %Container

var character : CharacterInfo :
	set(value) :
		character = value
		update_fields()

func update_fields() -> void :
	_field_container.visible = character != null
	if character != null :
		for field in find_children("", "DataField", true) :
			field.set_value(character.get(field.property_name))

func _get_field_values() -> Dictionary :
	var values : Dictionary = {}
	for field in find_children("", "DataField", true) :
		values[field.property_name] = field.get_value()
	return values

func _on_save_button_pressed() -> void:
	if character == null :
		printerr("Cannot save while character is null")
	for field in find_children("", "DataField", true) :
		character.set(field.property_name, field.get_value())
