@tool
extends Node3D

@export var play : bool : 
	set(value) :
		play = value
		if play : $AnimationPlayer.play("Slash")
