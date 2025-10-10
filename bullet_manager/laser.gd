extends RayCast2D

export (float) var cast_speed := 7000.0
export (float) var max_length := 1000.0
export (Color) var color := Color(1,1,1,1)
export (String) var faction := "enemy"

onready var line_2d: Line2D = $Line2D
onready var _base_line_width := line_2d.width
var _tween: SceneTreeTween = null

var _is_casting := false
var is_casting setget set_is_casting, get_is_casting

func _ready():
	if line_2d.points.size() < 2:
		line_2d.points = PoolVector2Array([Vector2.ZERO, Vector2.ZERO])
	line_2d.modulate = color
	line_2d.visible = false
	cast_to = Vector2.ZERO
	enabled = false
	set_physics_process(false)

func _physics_process(delta):
	var step: float = cast_speed * delta
	var new_len := min(cast_to.length() + step, max_length)
	cast_to = Vector2.RIGHT * new_len  # forward along local +X; rotate node to aim
	force_raycast_update()

	var end_pos := cast_to
	if is_colliding():
		end_pos = to_local(get_collision_point())

	var pts := line_2d.points
	pts.set(1, end_pos)                # PoolVector2Array safe set
	line_2d.points = pts

func set_is_casting(v: bool) -> void:
	if _is_casting == v:
		return
	_is_casting = v

	if _is_casting:
		cast_to = Vector2.ZERO
		enabled = true
		_appear()
		set_physics_process(true)
	else:
		_disappear()
		enabled = false
		set_physics_process(false)

func get_is_casting() -> bool:
	return _is_casting

func _appear() -> void:
	line_2d.show()
	if _tween and _tween.is_running(): _tween.kill()
	_tween = get_tree().create_tween()
	line_2d.width = 0.0
	_tween.tween_property(line_2d, "width", _base_line_width, 0.2)

func _disappear() -> void:
	if _tween and _tween.is_running(): _tween.kill()
	_tween = get_tree().create_tween()
	_tween.tween_property(line_2d, "width", 0.0, 0.1)
	_tween.tween_callback(line_2d, "hide")

func set_color(new_color: Color) -> void:
	color = new_color
	if line_2d:
		line_2d.modulate = new_color

# ---- API used by BulletManager ----
func fire(origin: Vector2, direction: Vector2,
		  p_faction: String = "player",
		  p_speed := 7000.0, p_max_length := 1000.0,
		  p_color := Color(1,1,1,1)) -> void:
	global_position = origin
	rotation = direction.angle()
	faction = p_faction
	cast_speed = p_speed
	max_length = p_max_length
	set_color(p_color)
	is_casting = true

func stop_and_free() -> void:
	is_casting = false
	yield(get_tree().create_timer(0.12), "timeout")
	queue_free()
