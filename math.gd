extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var loop = 7
	var rad = TAU/loop
	for i in loop:
		var radup = rad * i
		print(rad2deg(radup))
