@tool
extends DataField


@onready var _label : Label = %Label
@onready var _spinbox : SpinBox = %SpinBox

func _ready() -> void:
	_label.text = property_name.to_pascal_case()

func _on_property_name_set(value : String) -> void :
	if _label != null :
		_label.text = value.to_pascal_case()

func set_value(value : int) -> void :
	_spinbox.value = value

func get_value() -> int : 
	return int(_spinbox.value)
