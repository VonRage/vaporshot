extends KinematicBody2D
class_name EnemyBase


# Movement
export var speed: float = -100
export var stationary_speed: float = -100

# Shooting
export var shoot_interval: float = 2.0
var shoot_timer: float = 0
var player: KinematicBody2D = null
export var bullet_speed: float = 500

# Special behaviors
export var kamikaze_type : bool = false

# Scoring
export var points : int = 500


func _ready():
	_get_player()


func shot_timer(delta):
	shoot_timer += delta


#Movement functions

func _move_left_right(delta):
	self.position.x += speed * delta


func _move_toward_player(delta):
	if !player:
		_get_player()
	elif player:
		# Calculate direction to player
		var direction = (player.global_position - global_position).normalized()

		# Move toward player
		position += direction * -speed * delta
	else:
		Logger.error("Error @ move_toward_player on enemy_base")


func _move_toward_player_and_leave(delta):
	if player.global_position.x <= self.global_position.x:
		_move_toward_player(delta)
	else:
		_move_left_right(delta)


# Shot pattern functions

func _shoot_burst(num_bullets: int = 3, distancing: float = 0.15, shoot_dir: Vector2 = Vector2(-1, 0), rotation: float= 0):
	for i in num_bullets:
		BulletManager.spawn_bullet(
			global_position,
			shoot_dir,
			"enemy",
			bullet_speed,
			5.0,
			rotation
		)
		yield(get_tree().create_timer(distancing), "timeout")



func _shoot_aimed():
	if !player:
		_get_player()
	elif player:
		# Calculate direction to player's current position
		var shoot_dir = (player.global_position - global_position).normalized()

		# Spawn bullet via manager
		BulletManager.spawn_bullet(
			global_position,
			shoot_dir,
			"enemy",
			bullet_speed,
			5.0
		)
	else:
		printerr("Error calling _shoot_aimed")


func _shoot_aimed_burst(num_bullets: int = 3, distancing: float = 0.15):
	if !player:
		_get_player()
		print_debug("Had to get player %s" % player)
	elif player:
		# Spawn bullet via manager
		for i in num_bullets:
			# Calculate direction to player's current position
			var shoot_dir = (player.global_position - global_position).normalized()
			BulletManager.spawn_bullet(
				global_position,
				shoot_dir,
				"enemy",
				bullet_speed,
				5.0
			)
			yield(get_tree().create_timer(distancing), "timeout")
	else:
		printerr("Error calling _shoot_aimed")



func _shoot_ring(num_bullets: int = 8, ring_radius: float = 50, shoot_dir : Vector2 = Vector2(-1, 0)):
	for i in range(num_bullets):
		var angle = (i / float(num_bullets)) * TAU
		var offset = Vector2(cos(angle), sin(angle)) * ring_radius

		BulletManager.spawn_bullet(
			global_position + offset,
			shoot_dir,
			"enemy",
			bullet_speed,
			5.0
		)


func _shoot_expand(num_bullets = 8, ring_radius = 50):
	for i in range(num_bullets):
		var angle = (i / float(num_bullets)) * TAU
		var direction = Vector2(cos(angle), sin(angle))

		# Spawn at offset position around enemy
		var spawn_pos = global_position + (direction * ring_radius)

		BulletManager.spawn_bullet(
			spawn_pos,        # spawns in circle around enemy
			direction,        # moves outward from center
			"enemy",
			bullet_speed,
			5.0
		)


func _shoot_spread(num_bullets: int = 5, cone_angle: float = 45, shoot_dir: Vector2 = Vector2(-1, 0)):
	var cone_angle_rad = deg2rad(cone_angle)

	for i in range(num_bullets):
		# Spread bullets evenly across the circle
		var t = i / float(num_bullets - 1) if num_bullets > 1 else 0.5
		var offset_angle = (t - 0.5) * cone_angle_rad  # -cone/2 to +cone/2

		BulletManager.spawn_bullet(
			global_position,
			shoot_dir.rotated(offset_angle),
			"enemy",
			bullet_speed,
			5.0
		)


func _shoot_cone(num_bullets = 5, spread = 50):
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


func _get_player():
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null


func take_damage():
	GameStateManager.set_score(points)

	if kamikaze_type:
		_shoot_expand()

	queue_free()
