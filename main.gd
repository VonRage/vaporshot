extends Node2D


#var level_scene = preload("res://environment/level1.tscn")


func _ready():
	get_tree().paused = true


#func spawn_level():
#	var level
#
#	if !level_scene:
#		printerr("No level is loaded!")
#		return 1
#	level = level_scene.instance()
#	$LevelBase.add_child(level)
