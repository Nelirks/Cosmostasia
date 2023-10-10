extends Resource
class_name Effect

signal done()

var is_done : bool = false :
	set(value) :
		is_done = value
		done.emit()
		
var source : Character
var target : Character

func apply() -> void :
	pass
