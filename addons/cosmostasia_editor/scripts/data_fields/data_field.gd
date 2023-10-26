@tool
extends Control
class_name DataField

@export var property_name : String :
	set(value) :
		property_name = value 
		_on_property_name_set(value)

func _on_property_name_set(value : String) -> void :
	pass

func set_value(value) -> void :
	pass

func get_value() : 
	return null
