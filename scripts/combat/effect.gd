extends RefCounted
class_name Effect

signal done()

var is_done : bool = false :
	set(value) :
		is_done = value
		done.emit()

func apply() -> void :
	is_done = true
