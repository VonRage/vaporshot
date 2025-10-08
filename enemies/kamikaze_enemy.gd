extends KinematicBody2D

export var speed = 200
var player : KinematicBody2D = null
export var bullet_speed = 500

func _ready():
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null

func _physics_process(delta):
	if player:
		# Calculate direction to player
		var direction = (player.global_position - global_position).normalized()

		# Move toward player
		position += direction * speed * delta


func shoot_ring(num_bullets = 10):
	for i in range(num_bullets):
		var angle = (i / float(num_bullets)) * TAU  # TAU = 2*PI = full circle
		var direction = Vector2(cos(angle), sin(angle))

		BulletManager.spawn_bullet(
			global_position,
			direction,
			"enemy",
			bullet_speed,
			5.0
		)


func take_damage():
	call_deferred("shoot_ring")
	queue_free()
