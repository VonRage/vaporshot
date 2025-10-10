extends EnemyBase

onready var laser_pivot := $LaserPivot
var laser = null
enum { IDLE, CHARGING, FIRING, COOLDOWN }
var state = IDLE
var charge_time := 0.6
var fire_time := 1.2
var _timer := 0.0
var should_start_laser: bool = false

func _physics_process(delta):
	match state:
		IDLE:
			if should_start_laser:   # your condition
				start_charge()
		CHARGING:
			_timer -= delta
			update_laser_aim()
			if _timer <= 0.0:
				start_fire()
		FIRING:
			_timer -= delta
			update_laser_aim()
			if _timer <= 0.0:
				stop_laser()
				state = COOLDOWN
				_timer = 0.8
		COOLDOWN:
			_timer -= delta
			if _timer <= 0.0:
				state = IDLE

func start_charge():
	# spawn attached; laser will "appear" (width tween) but not at full length yet
	var dir = aim_dir()  # e.g., (player.global_position - muzzle.global_position).normalized()
	laser = BulletManager.spawn_laser_attached(muzzle, dir, "enemy", 7000.0, 1200.0, Color.red)
	laser.is_casting = false       # keep hidden while charging
	laser._appear()                # optional: thin pre-flash
	state = CHARGING
	_timer = charge_time

func start_fire():
	if not is_instance_valid(laser): return
	laser.cast_speed = 9000.0
	laser.max_length = 1200.0
	laser.is_casting = true        # actually extend and collide
	state = FIRING
	_timer = fire_time

func stop_laser():
	if is_instance_valid(laser):
		laser.stop_and_free()
	laser = null

func update_laser_aim():
	if not is_instance_valid(laser): return
	var dir = aim_dir()
	# since laser is a child of muzzle, set its local rotation
	laser.rotation = dir.angle()

func aim_dir() -> Vector2:
	var target = get_tree().get_root().get_node("World/Player")  # adjust path
	var gdir = (target.global_position - muzzle.global_position).normalized()
	return gdir
