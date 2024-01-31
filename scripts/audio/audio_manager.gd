extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Wwise.register_game_obj(self, "AudioManager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func post_event(id) -> void :
	Wwise.post_event_id(id, self)

func post_event_deferred(id, delay : float) -> void :
	await get_tree().create_timer(delay).timeout
	Wwise.post_event_id(id, self)
