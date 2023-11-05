@tool
extends Control
class_name DataFieldContainer

@onready var _field_container : Control = %Container

var resource : Resource :
	set(value) :
		resource = value
		update_fields()

func update_fields() -> void :
	_field_container.visible = resource != null
	if resource != null :
		for field in find_children("", "DataField", true) :
			field.set_value(resource.get(field.property_name))

func _get_field_values() -> Dictionary :
	var values : Dictionary = {}
	for field in find_children("", "DataField", true) :
		values[field.property_name] = field.get_value()
	return values

func _on_save_button_pressed() -> void:
	if resource == null :
		printerr("Cannot save while character is null")
	for field in find_children("", "DataField", true) :
		resource.set(field.property_name, field.get_value())
