extends KinematicBody2D

# Movement
export var speed = -100

# Shooting
export var shoot_interval = 2.0
export var bullet_speed = 1250
var shoot_timer = 0
var player = null


func _ready():
	# Find player node
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null


func _physics_process(delta):
	# Move left to right
	position.x += speed * delta

	# Shooting timer
	shoot_timer += delta
	if shoot_timer >= shoot_interval and player:
		shoot()
		shoot_timer = 0


func shoot():
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


func take_damage():
	queue_free()
