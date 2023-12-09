extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$"First Character".character = GameManager.player.get_character(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
