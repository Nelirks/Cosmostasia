@tool
extends DataField

@onready var _label : Label = %Label
@onready var _line_edit : LineEdit = %LineEdit

func _ready() -> void:
	_label.text = property_name.to_pascal_case()

func _on_property_name_set(value : String) -> void :
	if _label != null :
		_label.text = value.to_pascal_case()

func set_value(value : String) -> void :
	_line_edit.text = value

func get_value() -> String : 
	return %LineEdit.text
