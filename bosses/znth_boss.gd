extends StaticBody2D
signal start_casting

onready var file_name = get_script().get_path().get_file()

var laser_scene = preload("res://bosses/laser.tscn")
onready var laser_pivot := $LaserPivot
onready var lasers: Array


func _ready():
	_spawn_lasers(8)


func _physics_process(_delta):
	var func_name: String = ("_physics_process")
	Logger.fine("%s.%s: Called" % [file_name, func_name])
	for i in lasers:
		print(lasers[i])
	Logger.info("%s.%s: set is_casting to %s" % [file_name, func_name, Input.is_action_pressed("shoot")])
	pass


func _spawn_lasers(amount: int):
	var loop = amount
	var rad = TAU/loop
	for i in loop:
		var l = laser_scene.instance()
		var angle = rad * i
		laser_pivot.add_child(l)
		lasers.append(l)
		lasers[i].rotation = angle
	print(lasers)

