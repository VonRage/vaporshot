extends StaticBody2D
signal start_casting

onready var file_name = get_script().get_path().get_file()

var laser_scene = preload("res://bosses/laser.tscn")
onready var laser_pivot := $LaserPivot
onready var lasers: Array
onready var laser_amount = 6
export var rotation_speed = -1.0
export var rotation_windup = 2.0
onready var lasers_active: bool = false

var tween = null
var rng = RandomNumberGenerator.new()

onready var player = get_tree().get_nodes_in_group("player")

export var health: = 25
onready var face: Sprite = $FaceSprite
export var flicker_amount: int = 3


func _ready():
	_spawn_lasers(laser_amount)


func _physics_process(delta):
	var func_name: String = ("_physics_process")
	Logger.fine("%s.%s: Called" % [file_name, func_name])
	if lasers_active == true:
		laser_pivot.rotation += rotation_speed * delta
	else:
		laser_pivot.rotation = 0
	Logger.info("%s.%s: set is_casting to %s" % [file_name, func_name, Input.is_action_pressed("shoot")])


func _spawn_lasers(amount: int):
	var loop = amount
	var rad = TAU/loop
	for i in loop:
		var l = laser_scene.instance()
		var angle = rad * i
		laser_pivot.add_child(l)
		lasers.append(l)
		lasers[i].rotation = angle


func _on_VisibilityEnabler2D_screen_entered():
	_laser_interval()


var interval: float
var timer

func _laser_interval() -> void:
	if timer != null:
		timer.queue_free()
	interval = rng.randf_range(5, 10)
	timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(interval)
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", self, "_laser_handler")


func _laser_handler():
	if lasers_active == false:
		for i in lasers.size():
				lasers[i].is_casting = true
		lasers_active = true
	elif lasers_active == true:
		for i in lasers.size():
				lasers[i].is_casting = false
		lasers_active = false
	else:
		Logger.error("Error ar laser_handler on boss")
	_laser_interval()


func take_damage():
	var func_name = "take_damage()"
	health -= 1
	if health >= 0:
		GameStateManager.boss_damaged()
		for i in flicker_amount:
			face.visible = false
			face.visible = true
	elif health < 0:
		health -= 1
		tween = create_tween()
		tween.tween_property(self, "modulate:a", 0, 1)
	else:
		Logger.error("%s.%s: Error" % [file_name, func_name])
