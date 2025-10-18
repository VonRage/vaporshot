extends Control


onready var file_name = get_script().get_path().get_file()
onready var time = Time.get_time_string_from_system()


func _ready():
	var func_name: String = ("_ready")
	Logger.trace("%s - %s.%s: Pause Menu Initialized" % [time, file_name, func_name])


func _unhandled_input(Input: InputEvent):
	var func_name = "_unhandled_input()"
	if Input.is_action_pressed("pause") and get_tree().paused == false:
		Logger.trace("%s - %s.%s: Pausing" % [time, file_name, func_name])
		get_tree().paused = true
		show()
		Logger.info("%s - %s.%s: Game Paused" % [time, file_name, func_name])

	elif Input.is_action_pressed("pause") and get_tree().paused == true:
		Logger.trace("%s - %s.%s: Unpausing" % [time, file_name, func_name])
		hide()
		get_tree().paused = false
		Logger.info("%s - %s.%s: Game Unpaused" % [time, file_name, func_name])
