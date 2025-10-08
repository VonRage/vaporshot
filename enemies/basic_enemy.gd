extends KinematicBody2D

# Movement
export var speed = -100

# Shooting
export var shoot_interval = 2.0
export var bullet_speed = 1250
var shoot_timer = 0
var player = null
var kamikaze : bool = false


func _ready():
	# Find player node
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null


func _physics_process(delta):
	# Move left to right
	position.x += speed * delta

	# Shooting timer
	shoot_timer += delta
	if shoot_timer >= shoot_interval and player:
		shoot_cone()
		shoot_timer = 0


func shoot_aimed():
	# Calculate direction to player's CURRENT position
	var shoot_direction = (player.global_position - global_position).normalized()

	# Spawn bullet via manager
	BulletManager.spawn_bullet(
		global_position,
		shoot_direction,
		"enemy",
		bullet_speed,
		5.0  # lifetime
	)


func shoot_ring(num_bullets = 8, ring_radius = 50, direction : Vector2 = Vector2(-1, 0)):
	for i in range(num_bullets):
		var angle = (i / float(num_bullets)) * TAU
		var offset = Vector2(cos(angle), sin(angle)) * ring_radius

		BulletManager.spawn_bullet(
			global_position + offset,
			direction,
			"enemy",
			bullet_speed,
			5.0
		)


func shoot_spread(num_bullets = 5, cone_angle = 45):
	var move_direction = Vector2(-1, 0)  # direction cone points
	var cone_angle_rad = deg2rad(cone_angle)

	for i in range(num_bullets):
		# Spread bullets evenly across the cone angle
		var t = i / float(num_bullets - 1) if num_bullets > 1 else 0.5
		var offset_angle = (t - 0.5) * cone_angle_rad  # -cone/2 to +cone/2

		# Rotate the base direction by offset_angle
		var bullet_dir = move_direction.rotated(offset_angle)

		BulletManager.spawn_bullet(
			global_position,
			bullet_dir,
			"enemy",
			bullet_speed,
			5.0
		)


func shoot_cone(num_bullets = 5, spread = 50):
	var move_direction = Vector2(-1, 0)  # direction they move
	var perpendicular = Vector2(move_direction.y, -move_direction.x)  # sideways

	for i in range(num_bullets):
		# Position along the V shape
		var t = i / float(num_bullets - 1) if num_bullets > 1 else 0.5
		var side_offset = (t - 0.5) * spread  # -spread/2 to +spread/2
		var forward_offset = abs(t - 0.5) * spread  # V shape depth

		var spawn_pos = global_position + (perpendicular * side_offset) - (move_direction * forward_offset)

		BulletManager.spawn_bullet(
			spawn_pos,
			move_direction,  # all move same direction
			"enemy",
			bullet_speed,
			5.0
		)


func take_damage():
	if kamikaze:
		pass
	else:
		queue_free()
