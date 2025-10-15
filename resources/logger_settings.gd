# Log Levels
#ALL
#FINE
#TRACE
#DEBUG
#INFO
#WARN
#ERROR
#FATAL
#NONE

# Categories
#CATEGORY_GENERAL = "general"
#CATEGORY_WARN = "warn"
#CATEGORY_ERROR = "error"
#CATEGORY_SYSTEM = "system"
#CATEGORY_INPUT = "input"
#CATEGORY_GUI = "gui"
#CATEGORY_SIGNAL = "signal"
#CATEGORY_BEHAVIOR = "behavior"
#CATEGORY_FSM = "fsm"
#CATEGORY_NETWORK = "network"
#CATEGORY_PHYSICS = "physics"
#CATEGORY_GAME = "game"
#CATEGORY_AUDIO = "audio"
#CATEGORY_CAMERA = "camera"

# Layouts
#LOG_FORMAT_SIMPLE = 20   :
#LOG_FORMAT_DEFAULT = 30  :
#LOG_FORMAT_MORE = 90     :
#LOG_FORMAT_FULL = 99     :
#LOG_FORMAT_NONE = -1     :


#LOG_FORMAT_NONE (-1): 		Message
#LOG_FORMAT_SIMPLE (20):	MessageLine Message
#LOG_FORMAT_DEFAULT (30): 	Level MessageLine Message
#LOG_FORMAT_MORE (90):		Date Time Level MessageLine Message
#LOG_FORMAT_FULL (99):		Date Time Category Level MessageLine Message
#_: 						Date Time Message

extends Logger


func _ready():
#	spawn_level()
	Logger.logger_appenders.clear()
	var log_console = Logger.add_appender(ConsoleAppender.new())
	log_console.logger_level = Logger.LOG_LEVEL_WARN
	var log_file = Logger.add_appender(FileAppender.new("res://debug.log"))
	log_file.logger_level = Logger.LOG_LEVEL_INFO
	Logger.set_logger_format(Logger.LOG_FORMAT_FULL)
