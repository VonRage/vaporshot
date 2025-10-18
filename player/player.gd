extends KinematicBody2D


onready var file_name = get_script().get_path().get_file()
onready var time = Time.get_time_string_from_system()

onready var bullet : Area2D = null
onready var bullet_spawn : Position2D = $BulletSpawnPoint
export var fire_cooldown := 0.20
var time_since_shot := 0.0

onready var health: int = 3
const I_FRAMES: float = 2.0
export var i_frames: float = 2.0

var velocity : Vector2 = Vector2.ZERO
var current_velocity: Vector2 = Vector2.ZERO
export var acceleration: float = 800.0
export var friction: float = 600.0
export var speed : float = 750

var camera_addons = []
var shake_addon

export var god_mode: bool = false


func _ready():
	var func_name = "_ready"
	Logger.trace("%s - %s.%s: Initialized" % [time, file_name, func_name])
	call_deferred("_setup_camera_addons")

func _setup_camera_addons():
	var func_name = "_setup_camera_addons"
	Logger.trace("%s - %s.%s: Starting camera addon setup" % [time, file_name, func_name])

	var addons = procam.get_addons()

	if addons.size() > 0:
		camera_addons = addons
		Logger.info("%s - %s.%s: Found %d camera addon(s)" % [time, file_name, func_name, addons.size()])

		for i in range(addons.size()):
			if addons[i]:
				var addon_name = addons[i].get_script().get_path().get_file().get_basename()
				Logger.debug("%s - %s.%s: Registered addon [%d]: %s" % [time, file_name, func_name, i, addon_name])
	else:
		Logger.error("%s - %s.%s: No camera addons found!" % [time, file_name, func_name])

func _physics_process(delta):
	# Get input direction (works with both digital and analog inputs)
	# Uncomment if decide to not use analog input
	#var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var input_direction: Vector2 = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).clamped(1.0)

	if input_direction.length() > 0:
		# Uncomment if decide to not use analog input
		#input_direction = input_direction.normalized()
		current_velocity = current_velocity.move_toward(input_direction * speed, acceleration)
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, friction)

	move_and_slide(current_velocity, Vector2.UP)

	# Shooting logic
	var right: Vector2 = Vector2(1, 0)
	time_since_shot += delta
	if Input.is_action_pressed("shoot") and time_since_shot >= fire_cooldown:
		BulletManager.spawn_bullet(bullet_spawn.global_position, right, "player")
		time_since_shot = 0.0
	i_frames += delta


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		take_damage()


func take_damage():
	var func_name: String = "take_damage()"
	Logger.trace("%s.%s: Function called" % [file_name, func_name])

	if god_mode == true:
		return

	if i_frames >= I_FRAMES:
		health -= 1
		if health > 0:
			GameStateManager.health_changed(health)
			i_frames = 0
			if camera_addons.size() > 0:
				camera_addons[0].shake()
		elif health <= 0:
			GameStateManager.health_changed(health)
			get_tree().reload_current_scene()
		else:
			Logger.error("%s.%s: Error" % [file_name, func_name])
