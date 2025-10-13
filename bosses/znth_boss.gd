extends KinematicBody2D


onready var laser := $LaserPivot/Laser
onready var laser_pivot := $LaserPivot


func _ready():
	var log_file = Logger.add_appender(FileAppender.new("res://debug.log"))
	log_file.logger_level = Logger.LOG_LEVEL_DEBUG

func _process_physics(delta):
	look_at(get_global_mouse_position())
	laser.is_casting = Input.is_action_pressed("shoot")