extends Node2D


#var level_scene = preload("res://environment/level1.tscn")


func _ready():
#	spawn_level()
	Logger.logger_appenders.clear()
	var log_console = Logger.add_appender(ConsoleAppender.new())
	log_console.logger_level = Logger.LOG_LEVEL_ERROR
	var log_file = Logger.add_appender(FileAppender.new("res://debug.log"))
	log_file.logger_level = Logger.LOG_LEVEL_DEBUG


#func spawn_level():
#	var level
#
#	if !level_scene:
#		printerr("No level is loaded!")
#		return 1
#	level = level_scene.instance()
#	$LevelBase.add_child(level)