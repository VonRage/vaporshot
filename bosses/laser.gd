extends RayCast2D


export var cast_speed: float = 7000.0
export var max_length: float = 1400.0

export var color: Color = Color.blue setget set_color
onready var line_2d = $Line2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_color(color)
	set_is_casting(is_casting)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	cast_to.x = move_toward(
		cast_to.x,
		max_length,
		cast_speed * delta
	)

	force_raycast_update()

	if is_colliding():
		cast_to = to_local(get_collision_point())
	line_2d.points[1] = cast_to


export var is_casting: bool = false setget set_is_casting

func set_is_casting(new_value: bool) -> void:
	if is_casting == new_value:
		return
	is_casting = new_value

	if not line_2d:
		Logger.error("set_is_casting @ laser: !line_2d")
		return

	set_physics_process(is_casting)

	if is_casting == false:
		cast_to = Vector2.ZERO
		disappear()
	else:
		appear()


export var growth_time: float = 0.1
var tween = null
onready var line_width = line_2d.width

func appear() -> void:
	line_2d.visible = true
	if tween and tween.is_running():
		Logger.warn("appear @ laser: tween already exists, killing")
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", line_width, growth_time).from(0.0)


func disappear() -> void:
	if tween and tween.is_running():
		Logger.warn("disappear @ laser: tween already exists, killing")
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", 0.0, growth_time).from_current()
	tween.tween_callback(line_2d.hide)


func set_color(new_color: Color) -> void:
	color = new_color
	if !line_2d:
		Logger.error("set_color @ laser: !line2d")
		return
	line_2d.modulate = new_color
