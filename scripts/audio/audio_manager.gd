extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Wwise.register_game_obj(self, "AudioManager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func call_event_id(id) -> void :
	Wwise.post_event_id(id, self)
