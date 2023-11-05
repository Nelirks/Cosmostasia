@tool
extends Control
class_name CharacterFields

signal query_save(data : Dictionary)

func update_fields(character : CharacterInfo) -> void :
	visible = character != null
	if character != null :
		for field in find_children("", "DataField", true) :
			field.set_value(character.get(field.property_name))

func _get_field_values() -> Dictionary :
	var values : Dictionary = {}
	for field in find_children("", "DataField", true) :
		values[field.property_name] = field.get_value()
	return values

func _on_save_button_pressed() -> void:
	query_save.emit(_get_field_values())
