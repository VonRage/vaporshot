extends RayCast2D


onready var file_name = get_script().get_path().get_file()

export var cast_speed: float = 7000.0
export var max_length: float = 1400.0

export var color: Color = Color.blue setget set_color
onready var line_2d: Line2D = $Line2D
onready var line_2d_point1 = line_2d.points[1]
var pd = print_debug()


# Called when the node enters the scene tree for the first time.
func _ready():
	var func_name = ("_ready()")
	Logger.trace("%s.%s: Initialized" % [file_name, func_name])
	set_color(color)
	set_is_casting(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var func_name = ("_physics_process")
	Logger.fine("%s.%s: Called" % [file_name, func_name])

	cast_to.x = move_toward(
		cast_to.x,
		max_length,
		cast_speed * delta
	)

	force_raycast_update()

	if is_colliding():
		var collision_point = to_local(get_collision_point())
		Logger.info("%s.%s: Laser detecting collision at %s" % [file_name, func_name, collision_point])
		cast_to = collision_point
		Logger.info("%s.%s: cast_to set to %s" % [file_name, func_name, collision_point])
		line_2d_point1 = cast_to
		Logger.info("%s.%s: Child node property %s set to %s" % [file_name, func_name, line_2d_point1, cast_to])


export var is_casting: bool = false setget set_is_casting

func set_is_casting(new_value: bool) -> void:
	var func_name = ("set_is_casting")
	Logger.fine("%s.%s: Called with arg: %s" % [file_name, func_name, new_value])
	if is_casting == new_value:
		return
	is_casting = new_value
	Logger.info("%s.%s: is_casting set to %s" % [file_name, func_name, is_casting])

	if not line_2d:
		Logger.info("%s.%s: not line_2d" % [file_name, func_name])
		return

#	self.set_physics_process(is_casting)

	if is_casting == false:
		cast_to = Vector2.ZERO
		disappear()
	else:
		appear()


export var growth_time: float = 0.1
var tween = null
onready var line_width = line_2d.width

func appear() -> void:
	var func_name: String = ("appear")
	Logger.trace("%s.%s: Called" % [file_name, func_name])
	line_2d.visible = true
	if tween and tween.is_running():
		Logger.warn("appear @ laser: tween already exists, killing")
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", line_width, growth_time).from(0.0)


func disappear() -> void:
	var func_name: String = ("disappear")
	Logger.trace("%s.%s: Called" % [file_name, func_name])
	if tween and tween.is_running():
		Logger.warn("disappear @ laser: tween already exists, killing")
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", 0.0, growth_time).from_current()
	tween.tween_callback(line_2d, "hide")


func set_color(new_color: Color) -> void:
	var func_name: String = ("set_color")
	Logger.trace("%s.%s: Called" % [file_name, func_name])
	color = new_color
	if !line_2d:
		Logger.warn("set_color @ laser: !line2d")
		return
	line_2d.modulate = new_color
