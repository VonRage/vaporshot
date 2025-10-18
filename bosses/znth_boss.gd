extends EnemyBase


onready var file_name = get_script().get_path().get_file()

var laser_scene = preload("res://bosses/laser.tscn")
onready var laser_pivot := $LaserPivot
onready var lasers: Array
export var laser_amount = 6
export var rotation_speed = -1.0
export var rotation_windup = 2.0
onready var lasers_active: bool = false

var tween = null
var rng = RandomNumberGenerator.new()

onready var can_be_damaged: bool = false
export var health: = 25
onready var face: Sprite = $FaceSprite
export var flicker_amount: int = 3

export var burst_count: int = 3
export var burst_interval: float = 0.15


func _ready():
	._get_player()


func _physics_process(delta):
	var func_name: String = ("_physics_process")
	Logger.fine("%s.%s: Called" % [file_name, func_name])
	if lasers_active == true:
		laser_pivot.rotation += rotation_speed * delta
	else:
		laser_pivot.rotation = 0
		.shot_timer(delta)
		if shoot_timer >= shoot_interval:
			._shoot_aimed_burst(burst_count, burst_interval)
			shoot_timer = 0.0
	Logger.info("%s.%s: set is_casting to %s" % [file_name, func_name, Input.is_action_pressed("shoot")])


# Spawns in lasers
func _spawn_lasers(amount: int):
	var loop = amount
	var rad = TAU/loop
	for i in loop:
		var l = laser_scene.instance()
		var angle = rad * i
		laser_pivot.add_child(l)
		lasers.append(l)
		lasers[i].rotation = angle
		lasers[i].cast_to.x = 0


func _on_VisibilityEnabler2D_screen_entered():
	_laser_interval()
	GameStateManager.boss_on_screen()
	yield(get_tree().create_timer(1), "timeout")
	can_be_damaged = true


var interval: float
var timer

# Timing for lasers being on/off
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


# Triggering the lasers to be active
func _laser_handler():
	if lasers_active == false:
		_spawn_lasers(laser_amount)
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
	if can_be_damaged == true:
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
